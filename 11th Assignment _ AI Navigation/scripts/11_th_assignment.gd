extends Node3D

func _ready() -> void:
	NavigationServer3D.map_set_cell_size(	NavigationServer3D.get_maps()[0], 
											0.1)
	NavigationServer3D.map_set_cell_height(	NavigationServer3D.get_maps()[0], 
											0.1)
	$NavigationRegion3D.bake_navigation_mesh()

func _on_gate_closed_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableWall, "position:z", 1.095, 0.5).from_current()
	else:
		tween.tween_property(%MovableWall, "position:z", 3.0, 0.5).from_current()
	tween.tween_callback(func(): $NavigationRegion3D.bake_navigation_mesh())

func _on_change_camera_toggle_toggled(_toggled_on: bool) -> void:
	$Camera3D2.current = !$Camera3D2.current
	#$Camera3D.current = !$Camera3D.current
	
func _on_reset_scene_btn_pressed() -> void:
	get_tree().reload_current_scene()

func _on_gate_lifted_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableWall, "position:y", 1.0, 0.5).from_current()
	else:
		tween.tween_property(%MovableWall, "position:y", 0.465, 0.5).from_current()
	tween.tween_callback(func(): $NavigationRegion3D.bake_navigation_mesh())
