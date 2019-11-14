extends Area2D



var button

func _process(delta):
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("ui_shoot")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("ui_shoot", main.controller_layout)
	else:
		button = "X"
	
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.has_bullet:
					$Text.text = button + ": shoot"
					$Tween.interpolate_property($Text, "percent_visible", 0, 1, 0.5,
												Tween.TRANS_LINEAR, Tween.EASE_IN)
					$Tween.start()

func _ready():
	visible = true



