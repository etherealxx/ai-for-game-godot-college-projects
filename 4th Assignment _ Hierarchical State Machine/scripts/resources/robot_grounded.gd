extends RobotStateRes
class_name RobotGroundedRes

var robot : CharacterBody2D

func Enter() -> void:
	if parent_reference:
		robot = parent_reference
		
func Physics_Update(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up") and robot.is_on_floor():
		Transitioned.emit(self, "robotjumping")
