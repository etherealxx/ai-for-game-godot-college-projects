extends Resource
class_name StateMachineRes

var parent : CharacterBody2D

@export var initial_state : RobotStateRes

var current_state : RobotStateRes
@export var possible_states : Array[Script]
var states : Dictionary = {}

func _ready() -> void:
	#child.Transitioned.connect(_on_child_transition)
	#
	#if initial_state:
		#initial_state.Enter()
		#current_state = initial_state
	pass
	
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func _on_child_transition(state, next_state_name : String):
	if state != current_state:
		return
		
	var new_state : RobotStateRes = states.get(next_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
