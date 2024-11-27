#extends Camera3D
#
#@export var character : CharacterBody3D
#
#var offset : Vector3
#
#func _ready() -> void:
	#offset = self.position
#
#func _physics_process(delta: float) -> void:
	#if character:
		#var xz_pos = Vector3(
			#character.position.x + offset.x,
			#self.position.y,
			#character.position.z + offset.z
		#)
		#self.position = xz_pos
