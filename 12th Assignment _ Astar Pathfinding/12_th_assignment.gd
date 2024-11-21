extends Node3D

@export var bake_pointer : CharacterBody3D

@onready var buttongroup : ButtonGroup = %CheckBox.get_button_group()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var navmap = $Region3D.get_navigation_map()
	NavigationServer3D.map_set_cell_size(navmap, 0.1)
	NavigationServer3D.map_set_cell_height(navmap, 0.1)
	buttongroup.pressed.connect(_on_checkboxes_toggled)
	if bake_pointer:
		bake_pointer.bake.connect(_on_bake)

func _on_bake():
	#$Region3D.bake_navigation_mesh()
	for agent : CharacterBody3D in \
	$Agents.get_children().filter(func(x): return x is CharacterBody3D):
		#var new_target = Marker3D.new()
		#$Markers.add_child(new_target)
		#new_target.global_position = bake_pointer.global_position
		#agent.target_character = get_path_to(new_target)
		agent.chasing_target = true

func _on_checkboxes_toggled(btn : BaseButton):
	for camera : Camera3D in %Cameras.get_children().filter(func(x): return x is Camera3D):
		camera.current = false
		if camera.name == btn.text:
			camera.current = true

func _on_reset_scene_btn_pressed() -> void:
	get_tree().reload_current_scene()
