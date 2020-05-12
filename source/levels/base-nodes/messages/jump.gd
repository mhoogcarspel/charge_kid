extends Area2D


var button

func _process(delta):
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("ui_jump")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("ui_jump", main.controller_layout)
	else:
		button = "Z"
	
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.write(button + ": jump")
	else:
		$Text.text = button + ": jump"

func _ready():
	visible = true



func _on_Timer_timeout():
	if $Text.percent_visible == 0:
		$Text.write(button + ": jump")



