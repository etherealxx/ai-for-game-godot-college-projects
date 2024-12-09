extends Node3D

var bone_enemy = load("res://13th Final Assignment/scenes/bone_minion.tscn")

@export var player_ref : CharacterBody3D

@onready var safespawnarea : AABB = $SafeSpawnArea.get_aabb()

var score := 0

func _ready() -> void:
	# maps needs to be force updated for some reason
	NavigationServer3D.map_force_update($NavigationRegion3D.get_navigation_map())
	
	for enemy in %Enemies.get_children().filter(func(x : Node): return x.is_in_group("enemy")):
		enemy.defeated.connect(_on_enemy_defeated)
	
	spawn_bone_minion()
	#new_bone_enemy._on_map_ready(-1) # bypass map change

func _on_enemy_defeated(): # add score
	score += 1
	%ScoreLabel.text = "Score : %d" % score

func _on_fullscreen_btn_toggled(toggled_on: bool) -> void:
	var window : Window = get_window()
	if toggled_on: window.set_mode(Window.MODE_MAXIMIZED)
	else: window.set_mode(Window.MODE_WINDOWED)

func _on_reset_scene_btn_pressed() -> void:
	get_tree().reload_current_scene()

func spawn_bone_minion():
	# on random spot
	var newenemy_spawnspot := Vector3.ZERO
	while (newenemy_spawnspot.is_equal_approx(Vector3.ZERO) \
	or !safespawnarea.has_point(newenemy_spawnspot)):
		newenemy_spawnspot = NavigationServer3D.region_get_random_point(
			$NavigationRegion3D.get_rid(),
			0, # layer 1, bit 0
			false)
	var new_bone_enemy : CharacterBody3D = bone_enemy.instantiate()
	%Enemies.add_child(new_bone_enemy)
	new_bone_enemy.target_character = new_bone_enemy.get_path_to(player_ref)
	new_bone_enemy.setup_target_character_pos()
	new_bone_enemy.global_position = newenemy_spawnspot
	new_bone_enemy.global_position.y = 0
	new_bone_enemy._on_map_ready(-1) # bypass map change
	new_bone_enemy.defeated.connect(_on_enemy_defeated)

func enemy_count() -> int:
	return %Enemies.get_children().filter(func(x): return x is CharacterBody3D).size()

func _on_enemy_spawn_timer_timeout() -> void:
	spawn_bone_minion()
	if enemy_count() < 2:
		$EnemySpawnTimer.start()

func _on_enemies_child_exiting_tree(_node: Node) -> void:
	# enemy less than 3
	#print("amount of enemies: %d" % %Enemies.get_children().filter(func(x): return x is CharacterBody3D).size())
	if $EnemySpawnTimer.is_inside_tree():
		if enemy_count() < 3 \
		and $EnemySpawnTimer.is_stopped():
			$EnemySpawnTimer.start()

func _on_debug_trail_btn_toggled(toggled_on: bool) -> void:
	for enemy in %Enemies.get_children().filter(func(x : Node): return x.is_in_group("enemy")):
		var navagent : NavigationAgent3D = enemy.get_node("NavigationAgent3D")
		navagent.debug_enabled = toggled_on
