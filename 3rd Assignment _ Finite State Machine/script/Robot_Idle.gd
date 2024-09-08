extends Robot_State
class_name RobotIdle

@export var robot : CharacterBody2D

func Enter() -> void:
	robot = get_tree().get_first_node_in_group("robot")
	
func Physics_Update(delta: float) -> void:
	if robot:
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
		
		robot.move_and_slide()
		
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			Transitioned.emit(self, "robotmoving")
