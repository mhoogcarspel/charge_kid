extends Area2D



func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and $Timer.is_stopped():
			body.write(InputMap.get_action_list("ui_jump")[0].as_text() + ": jump")
			$Timer.start()