extends Area2D


var button

func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		button = main.control_handler.get_keyboard_key_name("ui_jump")
	else:
		button = "Z"


func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and $Timer.is_stopped():
			body.write(button + ": jump")
			$Timer.start()