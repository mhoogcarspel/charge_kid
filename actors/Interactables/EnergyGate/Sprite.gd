extends Sprite



func _on_Timer_timeout():
	match frame:
		0:
			frame = randi()%2 + 1
		1:
			frame = randi()%2
			if frame == 1:
				frame = 2
		2:
			frame = randi()%2
	$Timer.start()


