extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.attack_tick(get_physics_process_delta_time())
	if !actor.check_attack_distance():
		if abs(0.0 - actor.get_anim_pos("AttackAnim")) < 0.1:
			actor.after_kill()
			return SUCCESS
	return RUNNING
