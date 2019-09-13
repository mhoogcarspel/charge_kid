extends Area2D



func _on_HoldMessage_body_entered(body):
	var button
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("ui_shoot")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("ui_shoot", main.controller_layout)
	else:
		button = "X"
	
	if body.is_in_group("player") and $Timer.is_stopped():
		body.write("Hold " + button + ": hold bullet in place", 2)
		$Timer.start()
