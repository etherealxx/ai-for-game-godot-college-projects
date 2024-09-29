extends CharacterBody3D

var hp := 5

func damaged():
	hp -= 1
	if hp <= 0:
		queue_free()
		return
	$SkeletonModel.toggle_flash()
	await get_tree().create_timer(0.5, true, true).timeout
	$SkeletonModel.toggle_flash()
