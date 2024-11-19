extends Node3D

var navmesh_agentsmall := NavigationMesh.new()
var navmesh_agentbig := NavigationMesh.new()
var navmap_small: RID = NavigationServer3D.map_create()
var navmap_big: RID = NavigationServer3D.map_create()
var navreg_small: RID = NavigationServer3D.region_create()
var navreg_big: RID = NavigationServer3D.region_create()
#var source_geometry_data: NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()

@onready var agent_big: CharacterBody3D = $AINavAgent_Big
@onready var agent_small: CharacterBody3D = $AINavAgent_Small
@onready var root_geometry: Node3D = $Region3D
@onready var finish_spot: Marker3D = $FinishSpot

func init_and_set_agent_radius_height(navmesh : NavigationMesh, radius : float, height : float):
	navmesh.cell_size = 0.1
	navmesh.cell_height = 0.1
	navmesh.border_size = 0.3
	navmesh.agent_radius = radius
	navmesh.agent_height = height

var v := false

func navmesh_parse_and_bake():
	var source_geometry_data: NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(navmesh_agentsmall, source_geometry_data, root_geometry)
	NavigationServer3D.bake_from_source_geometry_data(navmesh_agentsmall, source_geometry_data)
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
	#NavigationServer3D.map_set_cell_size(	NavigationServer3D.get_maps()[0], 
											#0.1)
	#NavigationServer3D.map_set_cell_height(	NavigationServer3D.get_maps()[0], 
											#0.1)
	
	init_and_set_agent_radius_height(navmesh_agentsmall, 0.1, 0.4)
	init_and_set_agent_radius_height(navmesh_agentbig, 0.19, 0.83)
	
	navmesh_parse_and_bake()
	navigation_map_setup()
	navreg_set_meshes()
	
	#NavigationServer3D.map_get_path(navmap_small,
									#agent_big.global_position,
									#finish_spot.global_position, true)
									#
	#NavigationServer3D.map_get_path(navmap_small,
									#agent_big.global_position,
									#finish_spot.global_position, true)
	
	agent_small.set_nav_map(navmap_small)
	agent_big.set_nav_map(navmap_big)
	
	#$NavigationRegion3D.bake_navigation_mesh()

func _on_gate_closed_toggle_toggled(toggled_on: bool) -> void:
	var tween = create_tween()
	if toggled_on:
		tween.tween_property(%MovableWall, "position:z", 1.095, 0.5).from_current()
	else:
		tween.tween_property(%MovableWall, "position:z", 3.0, 0.5).from_current()
	#tween.tween_callback(func(): $NavigationRegion3D.bake_navigation_mesh())
	tween.tween_callback(_on_obstacle_moved)

func _on_obstacle_moved():
	navmesh_parse_and_bake()
	navreg_set_meshes()

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
	tween.tween_callback(_on_obstacle_moved)
