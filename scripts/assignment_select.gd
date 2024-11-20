extends Control

var button_scene = load("res://scenes/scene_select_button.tscn")
var is_loading_scene := false
var selected_scene_path := ""
#@export var choosable_scenes : Array[PackedScene]
@export_file("*.tscn") var choosable_scenes_paths: Array[String]
@export_file("*.tscn") var scenes_needs_blender: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LoadingPercent.hide()
	%BlenderWarning.hide()
	#var editor_settings = EditorInterface.get_editor_settings()
	#if editor_settings.get_setting("filesystem/import/blender/blender_path").is_empty() \
	#or ProjectSettings.get_setting("filesystem/import/blender/enabled") == false:
		#for scenes in scenes_needs_blender:
			#choosable_scenes_paths.erase(scenes)

	for scenepath : String in choosable_scenes_paths:
		var button_inst : Button = button_scene.instantiate()
		var split_array = scenepath.get_base_dir().rsplit(",", true, 1)
		button_inst.text = split_array[0].trim_prefix("res://")
		button_inst.pressed.connect(_on_scene_button_press.bind(scenepath))
		%ButtonCont.add_child(button_inst)
		if scenepath in scenes_needs_blender and \
		ProjectSettings.get_setting("filesystem/import/blender/enabled") == false:
			button_inst.disabled = true
			%BlenderWarning.show()
			
func _on_scene_button_press(_scenepath):
	$ScrollAndWarn.hide()
	$LoadingPercent.show()
	ResourceLoader.load_threaded_request(_scenepath)
	selected_scene_path = _scenepath
	is_loading_scene = true
	#get_tree().change_scene_to_file(_scenepath)
	
func _process(_delta: float) -> void:
	if is_loading_scene:
		var progress : Array
		var scene_load_status = ResourceLoader.load_threaded_get_status(selected_scene_path, progress)
		$LoadingPercent.text = "%.2f%%" % floorf(progress[0]*100)
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene_packed = ResourceLoader.load_threaded_get(selected_scene_path)
			get_tree().change_scene_to_packed(new_scene_packed)
