extends Node3D

@export var mesh_to_flash : MeshInstance3D

func _ready() -> void:
	mesh_to_flash.set_surface_override_material(0,
	mesh_to_flash.get_surface_override_material(0).duplicate())

func toggle_flash():
	var mat : ShaderMaterial = mesh_to_flash.get_surface_override_material(0)
	mat.set_shader_parameter("hit_flash_enabled",
							!mat.get_shader_parameter("hit_flash_enabled"))
