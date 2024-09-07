@tool
extends CanvasLayer

@export var label_text := ""

func _ready() -> void:
	if not Engine.is_editor_hint():
		%Label.text = label_text

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		%Label.text = label_text
