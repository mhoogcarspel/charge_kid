extends Area2D



var button

func _process(_delta):
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("ui_boost")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("ui_boost", main.controller_layout)
	else:
		button = "C"
	
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.can_boost and $Timer.is_stopped():
				body.write(button + ": boost")
				$Timer.start()