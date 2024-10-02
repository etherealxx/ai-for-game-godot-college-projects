extends Resource
class_name RobotStateRes

@export var replacement_script : Script
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

func replace_script():
	set_script(replacement_script)
	
func give_parent_reference(node: Node):
	parent_reference = node

func state_name():
	pass
