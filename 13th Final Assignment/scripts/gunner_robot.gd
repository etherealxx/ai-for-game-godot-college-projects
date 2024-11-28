extends CharacterBody3D

#signal shoot(position : Vector3, rotation : Vector3)

const MAX_SPRINT_METER := 100

@onready var animtree: AnimationTree = $AnimationTree
@onready var enemy_detector: Area3D = $EnemyDetector
@onready var model: Node3D = $gunner_robot_model

@export var initial_state : GunnerState
@export var possible_state : Array[GunnerState] # won't be used at runtime
@export var camera_pivot : Node3D
@export var shoot_direction: Node3D
@export var bullets_groupnode: Node3D
@export var sprint_progress_bar: ProgressBar

var current_state : GunnerState
var states : Dictionary = {}

var sprint_meter := MAX_SPRINT_METER

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
	#print("length %.1f | position %.1f | delta %.1f " % \
	#[
	#animtree["parameters/Shoot/current_length"], 
	#animtree["parameters/Shoot/current_position"],
	#animtree["parameters/Shoot/current_delta"]
	#])
