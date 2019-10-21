extends Area2D



func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and $Timer.is_stopped():
			body.write("try using the momentum from a bullet boost!", 4)
			$Timer.start()


