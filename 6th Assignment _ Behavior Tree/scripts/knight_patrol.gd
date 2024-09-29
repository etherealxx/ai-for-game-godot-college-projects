extends CharacterBody3D

@export var patrolpointcol : Node3D
@export var animplyr : AnimationPlayer
@export var animtree : AnimationTree

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

enum PlayerState {IDLE, RUNNING, ATTACKING}
enum PlayerAnim {IDLE, RUNNING, ATTACKING = -1}

var state : PlayerState
var anim : PlayerAnim
var animblendvalue = [0,0,0,0]
var patrolpointpos_list : Array[Vector3]
var currentpatrolpoint = 0 # zero means haven't moved. 1 would be the first patrolpoint
var enemypos : Vector3
var do_once_tag : Dictionary

func _ready() -> void:
	state = PlayerState.RUNNING
	anim = PlayerAnim.IDLE
	if patrolpointcol:
		for node in patrolpointcol.get_children():
			if node.is_in_group("patrolpoint"):
				patrolpointpos_list.append(node.position)
				print("Added patrolpos: %v" % node.position)

func do_once(tag: String, function : Callable, reset_timer := -1.0):
	if !do_once_tag.has(tag):
		do_once_tag[tag] = true
		function.call()
		if reset_timer > 0.0:
			await get_tree().create_timer(reset_timer, true, true).timeout
			do_once_tag.erase(tag)

func animlerp(array : Array, delta) -> void:
	animblendvalue = [
		lerpf(animblendvalue[0], array[0], 15*delta),
		lerpf(animblendvalue[1], array[1], 15*delta),
		lerpf(animblendvalue[2], array[2], 15*delta),
		lerpf(animblendvalue[3], array[3], 15*delta)
	]

func print_anim_info(animname : String):
	var time : float
	var current_length : float
	var current_position : float
	var current_delta : float
	if "parameters/%s/time" % animname in animtree:
		time = animtree["parameters/%s/time" % animname]
	if "parameters/%s/current_length" % animname in animtree:
		current_length = animtree["parameters/%s/current_length" % animname]
	if "parameters/%s/current_position" % animname in animtree:
		current_position = animtree["parameters/%s/current_position" % animname]
	if "parameters/%s/current_delta" % animname in animtree:
		current_delta = animtree["parameters/%s/current_delta" % animname]
	print("time : %.2f | len : %.2f | pos : %.2f | delta : %.2f" % 
	[time, current_length, current_position, current_delta])

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
				#print_anim_info("AttackAnim") #@TODO curent_pos 0.6667 for attack
				
	animtree["parameters/RunBlend/blend_amount"] = animblendvalue[0]
	animtree["parameters/AttackBlend/blend_amount"] = animblendvalue[1]

func change_state(next_state : PlayerState) -> void:
	if state != next_state:
		state = next_state
		print("state changed to: %s" % next_state)

func wait_for_next_run():
	change_state(PlayerState.IDLE)
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
			if !patrolpointpos_list.is_empty(): # and not enemypos
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

	move_and_slide()
	handle_anim(delta)
	#return true
	
func after_kill():
	wait_for_next_run()
	
func get_anim_pos(animname : String):
	var current_position := -1.0
	if "parameters/%s/current_position" % animname in animtree:
		current_position = animtree["parameters/%s/current_position" % animname]
	return current_position
	
func attack_tick(delta):
	#change_state(PlayerState.ATTACKING)
	if abs(0.67 - get_anim_pos("AttackAnim")) < 0.1:
		do_once("attack_hit", func(): hit_enemy(), 0.3)
	handle_anim(delta)

func hit_enemy():
	if $EnemyDetector.has_overlapping_bodies():
		var bodies = $EnemyDetector.get_overlapping_bodies()
		bodies[0].damaged()

func _on_idle_timer_timeout() -> void:
	if currentpatrolpoint + 1 > patrolpointpos_list.size() - 1:
		currentpatrolpoint = 0
	else:
		currentpatrolpoint += 1
	change_state(PlayerState.RUNNING)

func check_enemy() -> bool:
	if $EnemyDetector.has_overlapping_bodies():
		var bodies = $EnemyDetector.get_overlapping_bodies()
		enemypos = bodies[0].position
		#print("detected")
		return true
	return false

func check_attack_distance() -> bool:
	if $EnemyAttackArea.has_overlapping_bodies():
		#var bodies = $EnemyDetector.get_overlapping_bodies()
		#enemypos = bodies[0].position
		return true
	return false

func get_detection_radius() -> float:
	return $EnemyDetector/CollisionShape3D.get_shape().get_radius()

func _on_enemy_detector_body_entered(_body: Node3D) -> void:
	pass
	#print("tes aja")
