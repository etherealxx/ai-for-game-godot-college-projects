extends RobotGroundedRes
class_name RobotIdleRes

func state_name():
	return "robotidle"

func Enter() -> void:
	super.Enter()
	#if parent_reference:
		#robot = parent_reference

func Physics_Update(delta: float) -> void:
	if robot:
		super.Physics_Update(delta)
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
			
		robot.velocity.x = move_toward(robot.velocity.x, 0, SPEED)
		robot.move_and_slide()
		
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			Transitioned.emit(self, "robotmoving")
