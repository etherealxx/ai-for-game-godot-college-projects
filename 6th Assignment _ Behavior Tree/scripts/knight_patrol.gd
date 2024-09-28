extends CharacterBody3D

@export var patrolpointcol : Node3D
@export var animplyr : AnimationPlayer
@export var animtree : AnimationTree

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

enum PlayerState {IDLE, RUNNING, ATTACKING = -1}
enum PlayerAnim {IDLE, RUNNING, ATTACKING = -1}

var state : PlayerState
var anim : PlayerAnim
var animblendvalue = [0,0,0,0]
var patrolpointpos_list : Array[Vector3]
var currentpatrolpoint = 0 # zero means haven't moved. 1 would be the first patrolpoint
var enemypos : Vector3

func _ready() -> void:
	state = PlayerState.RUNNING
	anim = PlayerAnim.IDLE
	if patrolpointcol:
		for node in patrolpointcol.get_children():
			if node.is_in_group("patrolpoint"):
				patrolpointpos_list.append(node.position)
				print("Added patrolpos: %v" % node.position)

func animlerp(array : Array, delta) -> void:
	animblendvalue = [
		lerpf(animblendvalue[0], array[0], 15*delta),
		lerpf(animblendvalue[1], array[1], 15*delta),
		lerpf(animblendvalue[2], array[2], 15*delta),
		lerpf(animblendvalue[3], array[3], 15*delta)
	]

func handle_anim(delta) -> void:
	if state == PlayerState.IDLE:
		animlerp([0,0,0,0], delta)
	else:
		#match (anim):
			#PlayerAnim.RUNNING:
				#animlerp([1,0,0,0], delta)
			#PlayerAnim.ATTACKING:
				#animlerp([0,1,0,0], delta)
		match (state):
			PlayerState.RUNNING:
				animlerp([1,0,0,0], delta)
			PlayerState.ATTACKING:
				animlerp([0,1,0,0], delta)
				
	animtree["parameters/RunBlend/blend_amount"] = animblendvalue[0]
	animtree["parameters/AttackBlend/blend_amount"] = animblendvalue[1]
	#animtree["parameters/RunBlend/blend_amount"] = animblendvalue[2]
	#animtree["parameters/JumpBlend/blend_amount"] = animblendvalue[3]

func change_state(next_state : PlayerState) -> void:
	if state != next_state:
		state = next_state

func wait_for_next_run():
	state = PlayerState.IDLE
	$IdleTimer.start()

#func _physics_process(delta: float) -> void:
	#patrol_tick(delta)

func has_target():
	return true if enemypos else false

func patrol_tick(delta):
	velocity = Vector3.ZERO
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#if !patrolpointpos_list.is_empty():
		##change_state(PlayerState.RUNNING)
		#var target_position = patrolpointpos_list[currentpatrolpoint]
		#var direction: Vector3 = (target_position - global_transform.origin).normalized()
		#velocity.y = 0.0
		#velocity = direction * SPEED
		#$Looker.look_at(target_position, Vector3.UP, true)
		#$KnightModel.rotation.y = lerp_angle($KnightModel.rotation.y, $Looker.rotation.y, 0.2)
		
	match (state):
		PlayerState.RUNNING:
			if !patrolpointpos_list.is_empty() and not enemypos:
				var target_position : Vector3 = patrolpointpos_list[currentpatrolpoint]
				var direction : Vector3 = (target_position - global_transform.origin).normalized()
				velocity.y = 0.0
				velocity = direction * SPEED
				$Looker.look_at(target_position, Vector3.UP, true)
				$KnightModel.rotation.y = lerp_angle($KnightModel.rotation.y, $Looker.rotation.y, 0.2)
				#if distance_to(target_position) < 0.1:
					#
					#PlayerState.IDLE
				if position.distance_to(target_position) < 0.1:
					wait_for_next_run()

	move_and_slide()
	handle_anim(delta)
	
func move_towards_enemy(delta):
	velocity = Vector3.ZERO
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match (state):
		PlayerState.RUNNING:
				var target_position : Vector3 = enemypos
				var direction : Vector3 = (target_position - global_transform.origin).normalized()
				velocity.y = 0.0
				velocity = direction * SPEED
				$Looker.look_at(target_position, Vector3.UP, true)
				$KnightModel.rotation.y = lerp_angle($KnightModel.rotation.y, $Looker.rotation.y, 0.2)
				#if distance_to(target_position) < 0.1:
					#
					#PlayerState.IDLE
				if position.distance_to(target_position) < 0.1:
					wait_for_next_run()

	move_and_slide()
	handle_anim(delta)
	#return true

func _on_idle_timer_timeout() -> void:
	if currentpatrolpoint + 1 > patrolpointpos_list.size() - 1:
		currentpatrolpoint = 0
	else:
		currentpatrolpoint += 1
	state = PlayerState.RUNNING

func check_enemy() -> bool:
	if $EnemyDetector.has_overlapping_bodies():
		var bodies = $EnemyDetector.get_overlapping_bodies()
		enemypos = bodies[0].position
		print("detected")
		return true
	return false


func _on_enemy_detector_body_entered(body: Node3D) -> void:
	print("tes aja")
