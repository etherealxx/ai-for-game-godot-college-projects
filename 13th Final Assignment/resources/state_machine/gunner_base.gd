extends GunnerState
class_name GunnerBase

const ANIM_BLEND_SPEED := 7.0
const SPEED = 5.0

var robot : CharacterBody3D
var animtree : AnimationTree
var input_dir := Vector2.ZERO

func Enter() -> void:
	#super.Enter()
	if parent_reference:
		robot = parent_reference
		animtree = robot.animtree

func Physics_Update(delta: float) -> void:
	if robot:
		#super.Physics_Update(delta)
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
		
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func animtree_set_condition(name : StringName, state : bool):
	animtree["parameters/conditions/%s" % name] = state

func animtree_get_blendpos(name : StringName) -> float:
	return animtree["parameters/%s/blend_position" % name]

func animtree_set_blendpos(name : StringName, blendpos : float):
	animtree["parameters/%s/blend_position" % name] = blendpos
