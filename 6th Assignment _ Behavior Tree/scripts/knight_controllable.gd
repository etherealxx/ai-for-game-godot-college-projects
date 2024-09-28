extends CharacterBody3D

@export var animplyr : AnimationPlayer
@export var animtree : AnimationTree

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

enum PlayerState {IDLE, RUNNING, ATTACKING = -1}
enum PlayerAnim {IDLE, RUNNING, ATTACKING = -1}

var state : PlayerState
var anim : PlayerAnim

var animblendvalue = [0,0,0,0]

func _ready():
	state = PlayerState.IDLE
	anim = PlayerAnim.IDLE

func animlerp(array : Array, delta):
	animblendvalue = [
		lerpf(animblendvalue[0], array[0], 15*delta),
		lerpf(animblendvalue[1], array[1], 15*delta),
		lerpf(animblendvalue[2], array[2], 15*delta),
		lerpf(animblendvalue[3], array[3], 15*delta)
	]

func handle_anim(delta):
	if state == PlayerState.IDLE:
		animlerp([0,0,0,0], delta)
	else:
		match (anim):
			PlayerAnim.RUNNING:
				animlerp([1,0,0,0], delta)
			PlayerAnim.ATTACKING:
				animlerp([0,1,0,0], delta)
	#
	animtree["parameters/RunBlend/blend_amount"] = animblendvalue[0]
	animtree["parameters/AttackBlend/blend_amount"] = animblendvalue[1]
	#animtree["parameters/RunBlend/blend_amount"] = animblendvalue[2]
	#animtree["parameters/JumpBlend/blend_amount"] = animblendvalue[3]

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		state = PlayerState.RUNNING
		anim = PlayerAnim.RUNNING
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		state = PlayerState.IDLE
		
	if input_dir != Vector2.ZERO:
		var target_angle = atan2(input_dir.x, input_dir.y)
		$KnightModel.rotation.y = lerp_angle($KnightModel.rotation.y, target_angle, 0.2)

	move_and_slide()
	handle_anim(delta)

## TODO Optimize
## TODO Move Camera code
#
#@export var speed = 2.0
#@export var mouse_camera_sensitivity = 0.01
#@export var controller_camera_sensitivity = 0.1
#@export var cam_max_v = 1.0
#@export var cam_min_v = -1.0
#@export var player_turn_smoothing = 0.2
#
#var camera_movement = Vector2()
#
#func _ready():
	## Makes your mouse disappear from the screen
	##Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#pass
#
#
#func _physics_process(delta):
	#var input_direction = Vector3()
	#input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#input_direction = input_direction.normalized()
#
	#var movement_direction = Vector3()
	#if input_direction != Vector3.ZERO:
		## The direction of movement will be the input direction rotated in the direction of the camera
		#movement_direction = input_direction
		## (angle() is calculated by comparing the +X (1, 0) and the point)
		## so z is x and x is y when converting 3D to 2D because it appears the Y-axis rotation in 3D is relative to the +Z axis
		## TODO Bug when turning towards the camera left to towards the camera right
		#var new_rotation = Vector2(movement_direction.z, movement_direction.x).angle()
		#$KnightModel.rotation.y = lerp($KnightModel.rotation.y, new_rotation, player_turn_smoothing)
#
	#velocity = Vector3()
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#velocity.x = movement_direction.x * speed
	#velocity.z = movement_direction.z * speed
	#
	#move_and_slide()
