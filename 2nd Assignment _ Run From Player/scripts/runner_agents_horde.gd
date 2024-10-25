extends Node3D

@export var target_chaser_character : NodePath

func _ready() -> void:
	for runner in get_children():
		#if "chaser_character" in runner:
		runner.chaser_character = target_chaser_character
