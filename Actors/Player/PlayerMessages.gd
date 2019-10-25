extends Label



onready var player = get_parent()

func _physics_process(_delta):
	if player.position.y <= 36:
		rect_position.y = 36
	else:
		rect_position.y = -36
	
	if rect_size.x >= 240:
		autowrap = true
		rect_size.x = 240
	else:
		autowrap = false
	
	var level = get_tree().get_nodes_in_group("level")[0]
	if is_instance_valid(level):
		if player.position.x < rect_size.x/2:
			rect_position.x = -player.position.x
		elif player.position.x > level.level_length - rect_size.x/2:
			rect_position.x = (level.level_length - player.position.x) - rect_size.x
		else:
			rect_position.x = -rect_size.x/2