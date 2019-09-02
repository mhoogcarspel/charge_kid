extends Label



onready var player = get_parent()

func _process(_delta):
	if player.position.y <= 36:
		rect_position.y = 36
	else:
		rect_position.y = -36