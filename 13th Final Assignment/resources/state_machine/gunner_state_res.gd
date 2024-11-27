extends Resource
class_name GunnerState

var parent_reference : Node
@warning_ignore("unused_signal")
signal Transitioned

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func Physics_Update(_delta: float) -> void:
	pass
	
func give_parent_reference(node: Node):
	parent_reference = node

func state_name():
	pass
