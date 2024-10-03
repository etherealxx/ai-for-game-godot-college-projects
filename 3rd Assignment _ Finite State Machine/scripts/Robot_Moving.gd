extends Robot_State
class_name RobotMoving

var robot : CharacterBody2D
var robotsprite : Sprite2D
var robotshadermat : Material
const SPEED = 400.0

func Enter() -> void:
	robot = get_tree().get_first_node_in_group("robot")
	robotsprite = robot.get_node("Sprite2D")
	robotshadermat = robotsprite.get_material()
	robotshadermat.set_shader_parameter("line_color",Color("ff1717"))
	robotshadermat.set_shader_parameter("effect_intensity", 1)

func Exit() -> void:
	robotshadermat.set_shader_parameter("effect_intensity", 0)

func Physics_Update(_delta: float) -> void:
	if robot:

		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			if direction == 1: robotsprite.set_flip_h(false)
			elif direction == -1: robotsprite.set_flip_h(true)
			robot.velocity.x = direction * SPEED
			robot.move_and_slide()
		else:
			robot.velocity.x = move_toward(robot.velocity.x, 0, SPEED)
			robot.move_and_slide()
			Transitioned.emit(self, "robotidle")
