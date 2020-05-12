extends Area2D



export (String) var message
export (float) var message_time = 2.0
onready var player_detected: bool = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true

func _on_Lv3SpMessage_body_entered(body):
	if body.is_in_group("player") and not player_detected:
		player_detected = true
		get_parent().write(message, message_time)
