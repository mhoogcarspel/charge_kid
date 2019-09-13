extends Area2D



var button

func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("ui_shoot")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("ui_shoot", main.controller_layout)
	else:
		button = "X"

func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.has_bullet and $Timer.is_stopped():
				body.write(button + ": shoot")
				$Timer.start()




