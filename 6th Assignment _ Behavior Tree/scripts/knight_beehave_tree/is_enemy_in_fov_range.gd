extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.check_enemy():
		return SUCCESS
	return FAILURE
