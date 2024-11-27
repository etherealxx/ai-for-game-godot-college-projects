extends Area3D

@export var speed: float = 5.0

var destroyed := false

func _ready() -> void:
	#$BlueBallDestroyedParticle.finished.connect(_on_particle_finished)
	pass

func _physics_process(delta: float) -> void:
	if !destroyed:
		var forward: Vector3 = transform.basis.z
		var movement: Vector3 = forward * speed * delta
		global_position += movement
		rotation_degrees.z += 2 * delta * 60
	else:
		if !$BlueBallDestroyedParticle.emitting:
			queue_free()

func spawn_death_particle():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$blueball_model.hide()
	$BlueBallDestroyedParticle.emitting = true
	destroyed = true

#func _on_particle_finished():
	#queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	pass
	#queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		spawn_death_particle()
