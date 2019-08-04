extends Area2D



func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.can_shoot and $Timer.is_stopped():
				body.write("X: shoot")
				$Timer.start()



func _on_Area2D_body_exited(player):
	if player.is_in_group("player"):
		player.write(" ")




