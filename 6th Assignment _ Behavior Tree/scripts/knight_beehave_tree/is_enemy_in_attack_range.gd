extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.check_attack_distance():
		actor.change_state(actor.PlayerState.ATTACKING)
		return SUCCESS
	return FAILURE
