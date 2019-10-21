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
	
	if player.position.x < rect_size.x/2:
		rect_position.x = -player.position.x
	elif player.position.x > player.level_length - rect_size.x/2:
		rect_position.x = (player.level_length - player.position.x) - rect_size.x
	else:
		rect_position.x = -rect_size.x/2