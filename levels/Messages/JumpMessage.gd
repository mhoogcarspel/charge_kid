extends Area2D
onready var main = get_tree().get_nodes_in_group("main")[0]


func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and $Timer.is_stopped():
			body.write(main.control_handler.get_button_name("ui_jump") + ": jump")
			$Timer.start()