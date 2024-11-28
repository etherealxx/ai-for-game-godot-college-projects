extends GunnerBase
class_name GunnerWalk

func state_name():
	return "gunnerwalk"

func Enter() -> void:
	super.Enter()

func Physics_Update(delta: float) -> void:
	if robot:
		super.Physics_Update(delta)
				
		if input_dir == Vector2.ZERO:
			Transitioned.emit(self, "gunneridle")
			return
		
		#animtree_set_condition("idle", false)
		#animtree_set_condition("is_moving", true)
		
		## -1 idle, 1 walk
		#animtree_set_blendpos(	"IdleWalk",
								#lerp(animtree_get_blendpos("IdleWalk"), 1.0, delta * ANIM_BLEND_SPEED)) 
		
		if Input.is_action_pressed("speed_modifier"):
			if robot.sprint_meter > 0:
				SPEED = 6.0
				animtree_set_scale("WalkScale", 2.0)
				if tick_timer_triggered() and robot.sprint_meter > 0:
					robot.sprint_meter -= 4	
		else:
			SPEED = 3.0
			animtree_set_scale("WalkScale", 1.0)
			if tick_timer_triggered() and robot.sprint_meter > 0:
				robot.sprint_meter += 1
		
		if robot.sprint_meter < 0: robot.sprint_meter = 0
		sprint_progress_bar.value = robot.sprint_meter
		
		animtree_set_blendamount(	"WalkBlend",
						lerp(animtree_get_blendamount("WalkBlend"), 1.0, delta * ANIM_BLEND_SPEED))
		
		var camera_y_rot = camera_pivot.rotation.y
		var camera_basis = Basis(Vector3.UP, camera_y_rot)
		var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		#var direction := (robot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction * -1 # inverted because player looks from behind
		robot.velocity.x = direction.x * SPEED
		robot.velocity.z = direction.z * SPEED
		
		robot.move_and_slide()
