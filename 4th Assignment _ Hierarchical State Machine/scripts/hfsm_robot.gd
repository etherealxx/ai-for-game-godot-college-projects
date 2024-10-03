extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#@export var test : TestRes
@export var test_state : RobotStateRes # won't be used ever
@export var label_to_show_state : Label
@export var initial_state : RobotStateRes
@export var possible_state : Array[RobotStateRes] # won't be used at runtime
var current_state : RobotStateRes
var states : Dictionary = {}

func _ready() -> void:
	for onestate in possible_state:
		#onestate.replace_script()
		#onestate.give_parent_reference(self)
		onestate.give_parent_reference(self)
		states[onestate.state_name()] = onestate
		onestate.Transitioned.connect(_on_child_transition)
		print("State registered: %s" % onestate.state_name())
	#if initial_state:
		#initial_state.replace_script()
		#initial_state.give_parent_reference(self)
		#initial_state.Enter()
		#current_state = initial_state
		
	initial_state = states[initial_state.state_name()]
	#initial_state.replace_script()
	#initial_state.give_parent_reference(self)
	initial_state.Enter()
	current_state = initial_state
	if label_to_show_state:
		label_to_show_state.text = "State: " + current_state.state_name().trim_prefix("robot")
	#test.set_script(test._script)
	#test.printthat()

#func _ready() -> void:
	##state_machine.parent = self
	##print(state_machine.parent.name)
	#for onestate in possible_state:
		#if onestate is RobotStateRes:
			#states[onestate.state_name.to_lower()] = onestate
			#onestate.Transitioned.connect(_on_child_transition)
	#if initial_state:
		#initial_state.Enter()
		#current_state = initial_state

func _process(delta: float) -> void:

	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func _on_child_transition(state, next_state_name : String):
	#print(state, next_state_name)
	if state != current_state:
		return
		
	var new_state : RobotStateRes = states.get(next_state_name)
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()

	#new_state.replace_script()
	#new_state.give_parent_reference(self)
	new_state.Enter()
	
	current_state = new_state
	if label_to_show_state:
		label_to_show_state.text = "State: " + current_state.state_name().trim_prefix("robot")
