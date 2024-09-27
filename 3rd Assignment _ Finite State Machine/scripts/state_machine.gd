extends Node

@export var initial_state : Robot_State

var current_state : Robot_State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is Robot_State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func _on_child_transition(state, next_state_name : String):
	if state != current_state:
		return
		
	var new_state : Robot_State = states.get(next_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
