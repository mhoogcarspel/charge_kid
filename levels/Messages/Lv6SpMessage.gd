extends Area2D



export (String) var message
export (float) var message_time = 2.0
onready var switch = get_parent().get_node("SwitchBody")
onready var player_has_entered: bool = false
var switch_state: bool setget switch_sentinel


func switch_sentinel(new_value) -> void:
	if new_value == true and switch_state == false and player_has_entered == false:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.write(message, message_time/2)
		self.queue_free()
	switch_state = new_value

func _physics_process(_delta):
	self.switch_state = switch.is_active()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_has_entered = true