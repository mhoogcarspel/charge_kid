extends Area2D




func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.can_boost and $Timer.is_stopped():
				body.write(InputMap.get_action_list("ui_boost")[0].as_text() + ": boost")
				$Timer.start()