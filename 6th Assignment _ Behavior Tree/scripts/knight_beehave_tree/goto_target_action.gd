extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.move_towards_enemy(get_physics_process_delta_time())
	return SUCCESS
