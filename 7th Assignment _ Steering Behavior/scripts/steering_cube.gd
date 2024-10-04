extends CharacterBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 4.5
const RAY_AMOUNT := 9
const RAY_ANGLE := 90.0
const RAY_LENGTH = 0.8
const AVOIDANCE_STRENGTH = 2.0

#func _ready() -> void:
	#DebugDraw3D.new_scoped_config().set_thickness(0.001)

func _physics_process(_delta: float) -> void:
	var avoidance = Vector3.ZERO
	# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	
	var base_rotation = global_transform.basis.get_euler().y
	var half_angle = RAY_ANGLE / 2.0
	var space_state = get_world_3d().direct_space_state
	
	for i in range(RAY_AMOUNT):
		var arrow_ray_color = Color(0, 0, 1)
		var angle_offset = deg_to_rad(-half_angle + i * (RAY_ANGLE / (RAY_AMOUNT - 1)))
		var ray_direction = Vector3(1, 0, 0).rotated(Vector3.UP, base_rotation + angle_offset).normalized()
		var ray_end = global_transform.origin + ray_direction * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(global_transform.origin, ray_end)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			arrow_ray_color = Color(1, 0, 0)
			#print("Hit at point: ", result.position)
			if angle_offset < 0: # Ray to the left
				avoidance -= Vector3(0, 0, AVOIDANCE_STRENGTH) # Steer right
			elif angle_offset > 0: # Ray to the right
				avoidance += Vector3(0, 0, AVOIDANCE_STRENGTH) # Steer left

		#DebugDraw3D.draw_arrow_ray(global_transform.origin, ray_direction, RAY_LENGTH, arrow_ray_color, 0.001)
		DebugDraw.draw_ray_3d(global_transform.origin, ray_direction, RAY_LENGTH, arrow_ray_color)

	velocity.x = SPEED
	velocity.z = 0 + avoidance.z
	
	move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	self.position.x = -4.0
