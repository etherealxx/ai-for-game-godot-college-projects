@tool
extends CanvasLayer

@export var label_text := ""
@export var display_fps := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		%Label.text = label_text
		%FPS.visible = display_fps
		
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		%Label.text = label_text
	else:
		if display_fps:
			%FPS.text = "FPS : %.0f" % Engine.get_frames_per_second()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene_assignment_select.tscn")
	
func _on_pin_button_toggled(toggled_on: bool) -> void:
	get_tree().get_root().set_flag(Window.FLAG_ALWAYS_ON_TOP, toggled_on)
