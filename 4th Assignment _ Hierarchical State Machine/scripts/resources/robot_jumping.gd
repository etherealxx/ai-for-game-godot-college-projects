extends RobotStateRes
class_name RobotJumpingRes

const JUMP_VELOCITY = -400.0

var robot :CharacterBody2D
var robotsprite : Sprite2D
var robotshadermat : Material

func state_name():
	return "robotjumping"

func Enter() -> void:
	if parent_reference:
		robot = parent_reference
		robotsprite = robot.get_node("Sprite2D")
		robotshadermat = robotsprite.get_material()
		robotshadermat.set_shader_parameter("line_color",Color("00a732"))
		robotshadermat.set_shader_parameter("effect_intensity", 1)
		robot.velocity.y = JUMP_VELOCITY

func Exit() -> void:
	robotshadermat.set_shader_parameter("effect_intensity", 0)

func Physics_Update(delta: float) -> void:
	if robot:
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
			robot.move_and_slide()
		else:
				Transitioned.emit(self, "robotidle")
