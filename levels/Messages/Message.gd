extends Area2D

export (String) var message
export (float) var message_time = 2.0

func _on_Area2D4_body_entered(body):
	if body.is_in_group("player"):
		body.write(message, message_time/2)
