extends Node3D

var navmesh_agentsmall := NavigationMesh.new()
var navmesh_agentbig := NavigationMesh.new()
var navmap_small: RID = NavigationServer3D.map_create()
var navmap_big: RID = NavigationServer3D.map_create()
var navreg_small: RID = NavigationServer3D.region_create()
var navreg_big: RID = NavigationServer3D.region_create()

@onready var agent_big: CharacterBody3D = $AINavAgent_Big
@onready var agent_small: CharacterBody3D = $AINavAgent_Small
@onready var root_geometry: Node3D = $Region3D
@onready var finish_spot: Marker3D = $FinishSpot
@onready var buttongroup : ButtonGroup = %CheckBox.get_button_group()

func init_and_set_agent_radius_height(navmesh : NavigationMesh, radius : float, height : float):
	navmesh.cell_size = 0.1
	navmesh.cell_height = 0.1
	navmesh.border_size = 0.3
	navmesh.agent_radius = radius
	navmesh.agent_height = height
	
func navmesh_parse_and_bake():
	var source_geometry_data: NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
	%FloorObstacle.affect_navigation_mesh = true
	NavigationServer3D.parse_source_geometry_data(navmesh_agentsmall, source_geometry_data, root_geometry)
	NavigationServer3D.bake_from_source_geometry_data(navmesh_agentsmall, source_geometry_data)
	%FloorObstacle.affect_navigation_mesh = false
	NavigationServer3D.parse_source_geometry_data(navmesh_agentsmall, source_geometry_data, root_geometry)
	NavigationServer3D.bake_from_source_geometry_data(navmesh_agentbig, source_geometry_data)
	
func navigation_map_setup():
	NavigationServer3D.map_set_active(navmap_small, true)
	NavigationServer3D.map_set_active(navmap_big, true)

	NavigationServer3D.region_set_map(navreg_small, navmap_small)
	NavigationServer3D.region_set_map(navreg_big, navmap_big)
	
	NavigationServer3D.map_set_cell_size(navmap_small, 0.1)
	NavigationServer3D.map_set_cell_height(navmap_small, 0.1)
	NavigationServer3D.map_set_cell_size(navmap_big, 0.1)
	NavigationServer3D.map_set_cell_height(navmap_big, 0.1)

func navreg_set_meshes():
	NavigationServer3D.region_set_navigation_mesh(navreg_small, navmesh_agentsmall)
	NavigationServer3D.region_set_navigation_mesh(navreg_big, navmesh_agentbig)

func _ready() -> void:
	buttongroup.pressed.connect(_on_checkboxes_toggled)
	
	init_and_set_agent_radius_height(navmesh_agentsmall, 0.1, 0.4)
	init_and_set_agent_radius_height(navmesh_agentbig, 0.19, 0.83)
	
	navmesh_parse_and_bake()
	navigation_map_setup()
	navreg_set_meshes()
	
	agent_small.set_nav_map(navmap_small)
	agent_big.set_nav_map(navmap_big)

func _on_gate_closed_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableWall, "position:z", 1.095, 0.5).from_current()
	else:
		tween.tween_property(%MovableWall, "position:z", 3.0, 0.5).from_current()
	tween.tween_callback(_on_obstacle_moved)

func _on_obstacle_moved():
	navmesh_parse_and_bake()
	navreg_set_meshes()

func _on_gate_lifted_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableWall, "position:y", 1.0, 0.5).from_current()
	else:
		tween.tween_property(%MovableWall, "position:y", 0.465, 0.5).from_current()
	tween.tween_callback(_on_obstacle_moved)

func _on_checkboxes_toggled(btn : BaseButton):
	for camera : Camera3D in %Cameras.get_children().filter(func(x): return x is Camera3D):
		camera.current = false
		if camera.name == btn.text:
			camera.current = true

func _on_floor_slided_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableFloor, "position:z", 1.067, 0.5).from_current()
	else:
		tween.tween_property(%MovableFloor, "position:z", -0.26, 0.5).from_current()
	tween.tween_callback(_on_obstacle_moved)

func _on_reset_scene_btn_pressed() -> void:
	get_tree().reload_current_scene()
