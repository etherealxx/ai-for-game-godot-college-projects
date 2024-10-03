extends RobotGroundedRes
class_name RobotMovingRes

var robotsprite : Sprite2D
var robotshadermat : Material
var delay_initial_value := 3
var stop_delay_before_transitioning := delay_initial_value # to allow rapidly moving left/right

func state_name():
	return "robotmoving"

func Enter() -> void:
	super.Enter()
	if robot:
		robotsprite = robot.get_node("Sprite2D")
		robotshadermat = robotsprite.get_material()
		robotshadermat.set_shader_parameter("line_color",Color("ff1717"))
		robotshadermat.set_shader_parameter("effect_intensity", 1)

func Exit() -> void:
	robotshadermat.set_shader_parameter("effect_intensity", 0)

func Physics_Update(delta: float) -> void:
	if robot:
		super.Physics_Update(delta)
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			stop_delay_before_transitioning = delay_initial_value
			if direction == 1: robotsprite.set_flip_h(false)
			elif direction == -1: robotsprite.set_flip_h(true)
			robot.velocity.x = direction * SPEED
			robot.move_and_slide()
		else:
			stop_delay_before_transitioning -= 1
			if stop_delay_before_transitioning <= 0:
				robot.velocity.x = move_toward(robot.velocity.x, 0, SPEED)
				robot.move_and_slide()
				Transitioned.emit(self, "robotidle")
