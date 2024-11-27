extends Marker3D

@export var character : CharacterBody3D
@onready var camera: Camera3D = $RobotCamera

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
