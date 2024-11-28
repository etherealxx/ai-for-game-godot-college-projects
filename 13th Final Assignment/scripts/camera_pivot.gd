extends Marker3D

@export var character : CharacterBody3D
@onready var camera: Camera3D = $RobotCamera

var mouse_lock := true

#var offset : Vector3

#func _ready() -> void:
	#offset = self.position

func _physics_process(delta: float) -> void:
	if character:
		var xz_pos = Vector3(
			character.position.x,
			self.position.y,
			character.position.z
		)
		self.position = xz_pos

	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y += 2 * delta * 60
	elif Input.is_action_pressed("ui_right"):
		rotation_degrees.y -= 2 * delta * 60
		
	if Input.is_action_pressed("ui_down") and rotation_degrees.x < 21:
		rotation_degrees.x += 2 * delta * 60
	elif Input.is_action_pressed("ui_up") and rotation_degrees.x > -55:
		rotation_degrees.x -= 2 * delta * 60

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_lock_toggle"):
		if mouse_lock: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_lock = !mouse_lock
	
	if event is InputEventMouseMotion:
		#camera.rotate_x(event.relative.y * 0.002) # up-down
		if rotation_degrees.x < 21 and rotation_degrees.x > -55:
			rotation_degrees.x += event.relative.y * 0.1
		rotate_y(-event.relative.x * 0.002) # left-right
		
