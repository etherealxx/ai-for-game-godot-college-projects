extends GunnerState
class_name GunnerBase

const ANIM_BLEND_SPEED := 7.0

var blueball = load("res://13th Final Assignment/scenes/blue_ball.tscn")

var robot : CharacterBody3D
var model : Node3D
var enemy_detector: Area3D
var animtree : AnimationTree
var camera_pivot : Node3D
var shoot_direction : Node3D
var bullets_groupnode : Node3D
var sprint_progress_bar : ProgressBar
var MAX_SPRINT_METER : int

var SPEED := 3.0
var input_dir := Vector2.ZERO
var is_shooting := false
var has_shooted := false

const TICK_TIMER_EVERY := 0.1 # seconds
var physics_tickrate : int = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
var ticktimer_max_value := roundi(physics_tickrate * TICK_TIMER_EVERY)
var ticktimer := ticktimer_max_value

func Enter() -> void:
	#super.Enter()
	if parent_reference:
		robot = parent_reference
		animtree = robot.animtree
		enemy_detector = robot.enemy_detector
		model = robot.model
		camera_pivot = robot.camera_pivot
		shoot_direction = robot.shoot_direction
		bullets_groupnode = robot.bullets_groupnode
		sprint_progress_bar = robot.sprint_progress_bar
		MAX_SPRINT_METER = robot.MAX_SPRINT_METER
		#sprint_meter = robot.sprint_meter
		
		if !enemy_detector.body_entered.is_connected(_on_enemy_detected):
			enemy_detector.body_entered.connect(_on_enemy_detected)
			
		if !enemy_detector.area_exited.is_connected(_on_bullet_outofrange):
			enemy_detector.area_exited.connect(_on_bullet_outofrange)

func Physics_Update(delta: float) -> void:
	if robot:
		#super.Physics_Update(delta)
		if not robot.is_on_floor():
			robot.velocity += robot.get_gravity() * delta
		
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		#var bodies = enemy_detector.get_overlapping_bodies()
		is_shooting = false
		var distance_enemies = Dictionary() # distance as key, enemy position as value
		for body : CharacterBody3D in enemy_detector.get_overlapping_bodies().filter( \
		func(x : Node3D): return x.is_in_group("enemy")):
			distance_enemies[robot.position.distance_to(body.position)] = body.position
		
		if !distance_enemies.is_empty():
			is_shooting = true
			var nearest_enemy_pos : Vector3 = distance_enemies[distance_enemies.keys().min()]
			var direction_to_opponent = (nearest_enemy_pos - robot.global_transform.origin).normalized()
			var target_yaw = atan2(direction_to_opponent.x, direction_to_opponent.z)
			model.rotation.y = lerp_angle(model.rotation.y, target_yaw, 0.15)

		#is_shooting = Input.is_action_pressed("ui_accept")
		#if Input.is_action_just_pressed("ui_accept"):
			#animtree_request_seek("ShootSeek", 0.0)
			
		animtree_set_blendamount(	"ShootBlend",
									lerp(animtree_get_blendamount("ShootBlend"),
									1.0 if is_shooting else 0.0,
									delta * ANIM_BLEND_SPEED))
		
		var shootanim_pos = snapped(animtree_get_currentplaybackpos("Shoot"), 0.01)
		#print(shootanim_pos)
		
		if is_shooting and !has_shooted and \
		(abs(shootanim_pos - 0.2) <= 0.02):
			has_shooted = true
			#print("shoot!")
			var new_bullet : Area3D = blueball.instantiate()
			bullets_groupnode.add_child(new_bullet)
			new_bullet.global_position = shoot_direction.global_position
			new_bullet.rotation = model.rotation + shoot_direction.rotation
		
		if abs(shootanim_pos - 0.0) <= 0.02:
			has_shooted = false

func _on_enemy_detected(body : Node3D):
	if body.is_in_group("enemy") and !is_shooting:
		animtree_request_seek("ShootSeek", 0.0)

func _on_bullet_outofrange(area : Area3D):
	if area.is_in_group("bullet"):
		area.spawn_death_particle()

func tick_timer_triggered() -> bool:
	ticktimer -= 1
	if ticktimer <= 0:
		ticktimer = ticktimer_max_value
		return true
	return false

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

func animtree_request_seek(name : StringName, playbackpos : float):
	animtree["parameters/%s/seek_request" % name] = playbackpos

func animtree_set_scale(name : StringName, scale : float):
	animtree["parameters/%s/scale" % name] = scale

func animtree_get_currentplaybackpos(name : StringName) -> float:
	var currentpos = animtree["parameters/%s/current_position" % name]
	return currentpos if typeof(currentpos) != TYPE_NIL else 0.0
