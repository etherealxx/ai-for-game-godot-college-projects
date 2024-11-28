extends GunnerBase
class_name GunnerIdle

func state_name():
	return "gunneridle"

func Enter() -> void:
	super.Enter()

func Physics_Update(delta: float) -> void:
	if robot:
		super.Physics_Update(delta)
		
		if input_dir != Vector2.ZERO:
			Transitioned.emit(self, "gunnerwalk")
			return
		
		#if Input.is_action_just_pressed("ui_accept"):
			#Transitioned.emit(self, "gunnershoot")
			#return
		
		#animtree_set_condition("idle", true)
		#animtree_set_condition("is_moving", false)
		
		## -1 idle, 1 walk
		#animtree_set_blendpos(	"IdleWalk",
								#lerp(animtree_get_blendpos("IdleWalk"), -1.0, delta * ANIM_BLEND_SPEED))
								
		if tick_timer_triggered() and robot.sprint_meter < MAX_SPRINT_METER:
			#print("triggered")
			robot.sprint_meter += 3
			if robot.sprint_meter > MAX_SPRINT_METER: robot.sprint_meter = MAX_SPRINT_METER
		
		sprint_progress_bar.value = robot.sprint_meter
				
		animtree_set_blendamount(	"WalkBlend",
								lerp(animtree_get_blendamount("WalkBlend"), 0.0, delta * ANIM_BLEND_SPEED))
		
		robot.velocity.x = move_toward(robot.velocity.x, 0, SPEED)
		robot.velocity.z = move_toward(robot.velocity.z, 0, SPEED)
		
		robot.move_and_slide()
