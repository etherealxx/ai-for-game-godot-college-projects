extends CharacterBody3D

var hp := 5

func damaged():
	hp -= 1
	$SkeletonModel.toggle_flash()
	if hp <= 0:
		$CollisionShape3D.set_disabled(true)
	await get_tree().create_timer(0.5, true, true).timeout
	$SkeletonModel.toggle_flash()
	if hp <= 0:
		queue_free()
