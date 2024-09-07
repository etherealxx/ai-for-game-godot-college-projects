extends CharacterBody3D

@export var chaser_character : NodePath
@onready var navagent : NavigationAgent3D = $NavigationAgent3D

var nav_speed := 0.7
var nav_accel := 10.0
var target_character_position : Vector3
var move_away := false

func _ready() -> void:
	navagent.target_desired_distance = 0.5
	#if chaser_character:
		#target_character_position = get_node(chaser_character).get_global_position()
	#call_deferred("actor_setup")

func set_movement_target(movement_target: Vector3):
	var xz_pos = Vector3(
		movement_target.x,
		self.position.y,
		movement_target.z
	)
	navagent.set_target_position(xz_pos)

func _physics_process(delta):
	if chaser_character and move_away:
		var direction := Vector3()
		
		direction = -navagent.get_next_path_position()
		var normalized_xz = Vector2(direction.x, direction.z).normalized()
		direction = Vector3(
			normalized_xz.x,
			0.0,
			normalized_xz.y # y is z
		)
		direction = direction * Quaternion(Vector3.UP, deg_to_rad(randf_range(-90, 90)))
		velocity = velocity.lerp(direction * nav_speed, nav_accel * delta)
		
		move_and_slide()
		
		# Assuming 'target_position' is the position you want to look away from
		var opposite_direction = global_position - (target_character_position - global_position)
		
		look_at(opposite_direction, Vector3.UP, true)

func _on_check_chaser_timer_timeout() -> void:
	var bodies : Array = $Area3D.get_overlapping_bodies()
	if not bodies.is_empty():
		for body in bodies:
			if body == get_node(chaser_character):
				target_character_position = get_node(chaser_character).get_global_position()
				set_movement_target(target_character_position - self.global_position)
				move_away = true
				break
	else:
		move_away = false
