extends CharacterBody3D

@export var target_character : NodePath

var movement_speed := 1.0
var movement_target_position := Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	if target_character:
		var target_character_position = $"../AINavAgent_Runner".get_global_position()
		set_movement_target(target_character_position)
		print(str(target_character_position))

func set_movement_target(movement_target: Vector3):
	var xz_pos = Vector3(
		movement_target.x,
		self.position.y,
		movement_target.z
	)
	navigation_agent.set_target_position(xz_pos)

func randpos():
	return randf_range(-3.0,3.0)

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return
		#movement_target_position = Vector3(randpos(),randpos(),randpos())
	
	var current_agent_position: Vector3 = global_position
	#if current_agent_position == movement_target_position:
		#movement_target_position = Vector3(randpos(),randpos(),randpos())
		#set_movement_target(movement_target_position)
		
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	print(str(current_agent_position))
	move_and_slide()
