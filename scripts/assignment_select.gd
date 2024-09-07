extends Control

#@export var choosable_scenes : Array[PackedScene]
@export_file("*.tscn") var choosable_scenes_paths: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for scenepath : String in choosable_scenes_paths:
		var button_inst = load("res://scenes/scene_select_button.tscn").instantiate()
		var split_array = scenepath.get_base_dir().rsplit(",", true, 1)
		button_inst.text = split_array[0].trim_prefix("res://")
		button_inst.pressed.connect(func(): get_tree().change_scene_to_file(scenepath))
		%ButtonCont.add_child(button_inst)
