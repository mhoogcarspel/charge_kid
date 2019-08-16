extends Area2D



func _on_HoldMessage_body_entered(body):
	var button
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		button = main.control_handler.get_button_name("ui_shoot")
	else:
		button = "X"
	
	if body.is_in_group("player") and $Timer.is_stopped():
		body.write("Hold " + button + ": hold bullet in place", 2)
		$Timer.start()
