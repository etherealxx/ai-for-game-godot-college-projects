extends CharacterBody3D

@export var target_character : NodePath
@onready var navagent : NavigationAgent3D = $NavigationAgent3D

@export var nav_speed := 0.4
var nav_accel := 10.0
var target_character_position : Vector3
var map_ready = false

func _ready() -> void:
	navagent.target_desired_distance = 0.5
	if target_character:
		target_character_position = get_node(target_character).get_global_position()
	NavigationServer3D.map_changed.connect(_on_map_ready)
	call_deferred("actor_setup")
	
func _on_map_ready(_rid):
	map_ready = true

func set_movement_target(movement_target: Vector3):
	var xz_pos = Vector3(
		movement_target.x,
		self.position.y,
		movement_target.z
	)
	navagent.set_target_position(xz_pos)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	if target_character_position:
		set_movement_target(target_character_position)
		print(str(target_character_position))

func _physics_process(delta):
	if target_character_position and map_ready:
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
		
		#look_at(target_character_position, Vector3.UP, true)
		if get_distance_to(get_node(target_character)) > 5.0:
			look_at(global_transform.origin + direction, Vector3.UP, true)

func _on_update_navtarget_timer_timeout() -> void:
	if target_character:
		target_character_position = get_node(target_character).get_global_position()
		set_movement_target(target_character_position)
		#print(str(get_distance_to(get_node(target_character))))
		#print(str(target_character_position))

func get_distance_to(body : Node) -> float:
	return self.global_position.distance_to(body.global_position)
