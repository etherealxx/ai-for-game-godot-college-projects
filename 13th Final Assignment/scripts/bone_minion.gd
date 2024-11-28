extends CharacterBody3D

signal defeated

@export var target_character : NodePath
@export var nav_speed := 3.0
@export var chasing_target := true

@onready var navagent : NavigationAgent3D = $NavigationAgent3D
@onready var model: Node3D = $BoneMinionModel

var nav_accel := 10.0
var target_character_position : Vector3
var map_ready := false
var hp := 3

func _ready() -> void:
	navagent.target_desired_distance = 0.5
	setup_target_character_pos()
	NavigationServer3D.map_changed.connect(_on_map_ready)
	call_deferred("actor_setup")
	$AnimationTree.tree_root = $AnimationTree.tree_root.duplicate(true)
	$AnimationTree.tree_root.start_offset = randf_range(0.0, 1.0)

func _on_map_ready(_rid):
	map_ready = true

func setup_target_character_pos():
	if target_character:
		target_character_position = get_node(target_character).get_global_position()

#func chase_target():
	#chasing_target = true

func set_movement_target(movement_target: Vector3):
	var xz_pos = Vector3(
		movement_target.x,
		self.position.y,
		movement_target.z
	)
	navagent.set_target_position(xz_pos)

func actor_setup():
	await get_tree().physics_frame
	if target_character_position:
		set_movement_target(target_character_position)
		print(str(target_character_position))

func _physics_process(delta):
	#print(target_character_position, map_ready, chasing_target)
	if target_character_position and map_ready and chasing_target:
		var direction := Vector3()
		
		direction = navagent.get_next_path_position() - self.global_position
		var normalized_xz = Vector2(direction.x, direction.z).normalized()
		direction = Vector3(
			normalized_xz.x,
			0.0,
			normalized_xz.y # y is z
		)
		#direction.y = 0.0 # prevents floating
		
		velocity = velocity.lerp(direction * nav_speed, nav_accel * delta)
		
		move_and_slide()
		
		if navagent.distance_to_target() > 0.05:
			#look_at(global_transform.origin + direction, Vector3.UP, true)
			var direction_to_target = (global_transform.origin + direction - global_transform.origin).normalized()
			var target_yaw = atan2(direction_to_target.x, direction_to_target.z)
			model.rotation.y = lerp_angle(model.rotation.y, target_yaw, 0.15)
		else:
			refresh_navigation()

func damaged():
	hp -= 1
	$BoneMinionModel.toggle_flash()
	if hp <= 0:
		$CollisionShape3D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5, true, true).timeout
	$BoneMinionModel.toggle_flash()
	if hp <= 0:
		queue_free()
		defeated.emit()

func refresh_navigation():
	chasing_target = false
	target_character_position = get_node(target_character).get_global_position()
	set_movement_target(target_character_position)
	chasing_target = true
	
func _on_update_navtarget_timer_timeout() -> void:
	if has_node(target_character):
		target_character_position = get_node(target_character).get_global_position()
		set_movement_target(target_character_position)

func get_distance_to(body : Node) -> float:
	return self.global_position.distance_to(body.global_position)

func _on_refresh_path_timeout() -> void:
	refresh_navigation()
