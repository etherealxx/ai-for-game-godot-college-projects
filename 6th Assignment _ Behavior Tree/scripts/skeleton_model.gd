extends Node3D

@export var mesh_to_flash : MeshInstance3D
#@onready var mesh_to_flash = $rig/Skeleton3D/LP_skeleton

func toggle_flash():
	var mat : ShaderMaterial = mesh_to_flash.get_surface_override_material(0)
	mat.set_shader_parameter("hit_flash_enabled",
							!mat.get_shader_parameter("hit_flash_enabled"))
