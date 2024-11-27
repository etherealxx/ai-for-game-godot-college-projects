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
		
		var direction := (robot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction * -1 # inverted because player looks from behind
		robot.velocity.x = direction.x * SPEED
		robot.velocity.z = direction.z * SPEED
		
		robot.move_and_slide()
