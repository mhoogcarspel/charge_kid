extends Area2D




func _on_Area2D4_body_entered(body):
	if body.is_in_group("player"):
		body.write("Totally intended")
