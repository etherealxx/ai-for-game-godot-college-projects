extends GunnerState
class_name GunnerBase

const ANIM_BLEND_SPEED := 7.0
const SPEED = 5.0

var robot : CharacterBody3D
var animtree : AnimationTree
var input_dir := Vector2.ZERO
var is_shooting := false

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
		
		is_shooting = Input.is_action_pressed("ui_accept")
		if Input.is_action_just_pressed("ui_accept"):
			animtree_request_seek("ShootSeek", 0.0)
		animtree_set_blendamount(	"ShootBlend",
									lerp(animtree_get_blendamount("ShootBlend"),
									1.0 if is_shooting else 0.0,
									delta * ANIM_BLEND_SPEED))
		

func animtree_set_condition(name : StringName, state : bool):
	animtree["parameters/conditions/%s" % name] = state

func animtree_get_blendpos(name : StringName) -> float:
	return animtree["parameters/%s/blend_position" % name]

func animtree_set_blendpos(name : StringName, blendpos : float):
	animtree["parameters/%s/blend_position" % name] = blendpos

func animtree_get_blendamount(name : StringName) -> float:
	return animtree["parameters/%s/blend_amount" % name]

func animtree_set_blendamount(name : StringName, blendamount : float):
	animtree["parameters/%s/blend_amount" % name] = blendamount

func animtree_request_seek(name : StringName, second_playback_position : float):
	animtree["parameters/%s/seek_request" % name] = second_playback_position
