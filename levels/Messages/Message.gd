extends Area2D

export (String) var message

func _on_Area2D4_body_entered(body):
	if body.is_in_group("player"):
		body.write(message)
