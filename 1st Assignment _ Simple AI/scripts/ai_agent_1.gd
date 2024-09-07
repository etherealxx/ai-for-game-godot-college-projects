extends CharacterBody3D

@export var SPEED := 20.0
@export var positionspeed := 1.0
const JUMP_VELOCITY := 4.5
var direction := 1.0
var turnvalue := 0.0
@export var turnspeed := 50
	
func _physics_process(delta: float) -> void:
	var collided_on_front = $Front_Ray.get_collider()
	var collided_on_back = $Back_Ray.get_collider()
	var collided_on_right = $Right_Ray.get_collider()
	var collided_on_left = $Left_Ray.get_collider()
	if $CooldownTimer.is_stopped() and (collided_on_front or collided_on_back):
		$CooldownTimer.start()
		direction = direction * -1.0
	
	turnvalue = 0.0
	if collided_on_left:
		turnvalue = -1.0
	elif collided_on_right:
		turnvalue = 1.0

	rotation_degrees.y += 5.0 * turnvalue * direction
	velocity.x = SPEED * delta * cos(rotation.y) * direction
	velocity.z = SPEED * delta * -sin(rotation.y) * direction

	move_and_slide()
