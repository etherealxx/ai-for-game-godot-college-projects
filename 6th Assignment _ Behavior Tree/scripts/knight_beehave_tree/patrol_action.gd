extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.patrol_tick(get_physics_process_delta_time())
	return SUCCESS
	#return RUNNING
