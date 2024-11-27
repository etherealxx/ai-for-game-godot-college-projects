extends CharacterBody3D

@onready var animtree: AnimationTree = $AnimationTree
@export var initial_state : GunnerState
@export var possible_state : Array[GunnerState] # won't be used at runtime

var current_state : GunnerState
var states : Dictionary = {}

func _ready() -> void:
	for onestate in possible_state:
		onestate.give_parent_reference(self)
		assert(!states.has(onestate.state_name()), "Duplicate state name found!")
		states[onestate.state_name()] = onestate
		onestate.Transitioned.connect(_on_child_transition)
		print("State registered: %s" % onestate.state_name())
		
	initial_state = states[initial_state.state_name()]
	initial_state.Enter()
	current_state = initial_state

func _on_child_transition(state, next_state_name : String):
	#print(state, next_state_name)
	#print("trying to transition into: %s" % next_state_name)
	if state != current_state:
		return
		
	var new_state : GunnerState = states.get(next_state_name)
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
