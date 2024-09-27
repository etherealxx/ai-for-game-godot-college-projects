extends Node

#@export var enemies : Array[PackedScene]
@export var enemies : Array[EnemyProp]
var accumulated_weights : float
var enemy_counter : Dictionary
	
func _ready() -> void:
	calculate_weights()
	for i in range(200):
		spawn_random_enemy(Vector2(randf_range(-400, 400),
									randf_range(-300, 300)))
	print("------------------------------------------------")
	for color_name in enemy_counter.keys():
		print("Color: %s | Amount : %d" % [color_name, enemy_counter[color_name]])

func spawn_random_enemy(_position : Vector2):
	var random_enemy_prop: EnemyProp = enemies[get_random_enemy_index()]
	var random_enemy = random_enemy_prop.scene.instantiate()
	self.add_child(random_enemy)
	random_enemy.position = _position
	print("Color: %s | Chance : %f" % [random_enemy_prop.color_name, random_enemy_prop._weight])
	add_counter(random_enemy_prop.color_name)
	
func add_counter(color_key : String):
	if !enemy_counter.has(color_key):
		enemy_counter[color_key] = 0
	enemy_counter[color_key] += 1

func get_random_enemy_index():
	var f = randf_range(0,1) * accumulated_weights
	for i in enemies.size():
		if enemies[i]._weight >= f:
			return i
	return 0

func calculate_weights():
	accumulated_weights = 0.0
	for enemy in enemies:
		accumulated_weights += float(enemy.chance)
		enemy._weight = accumulated_weights
