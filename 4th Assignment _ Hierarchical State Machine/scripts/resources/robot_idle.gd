extends RobotStateRes
class_name RobotIdleRes

var robot

func state_name():
	return "robotidle"

func Enter() -> void:
	if parent_reference:
		robot = parent_reference

func Physics_Update(delta: float) -> void:
	if robot:
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
		
		robot.move_and_slide()
		
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			Transitioned.emit(self, "robotmoving")
