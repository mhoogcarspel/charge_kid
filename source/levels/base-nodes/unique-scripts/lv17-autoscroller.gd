extends Node2D

export (float) var speed

onready var active: bool = true
onready var checkpoint_3_event_part: int = 0

onready var camera_placement = get_parent().get_node("Checkpoint3/CameraRespawnPoint")
onready var top_gate = get_parent().get_node("EnergyGate7")
onready var bottom_gate = get_parent().get_node("EnergyGate6")



func _physics_process(delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0]
		if $PauseTimer.is_stopped() and active and player.get_state() != "DyingState":
			if self.position.x < get_parent().level_length - 256:
				self.position.x = clamp(self.position.x + speed*delta, 0, get_parent().level_length - 256)
			else:
				$EnergyGate.position.x += speed*delta



func _on_Checkpoint3_body_entered(body):
	if body.is_in_group("player") and checkpoint_3_event_part == 0:
		active = false
		checkpoint_3_event_part = 1
		var final_pos = get_parent().get_node("Checkpoint3").position
		final_pos += get_parent().get_node("Checkpoint3/CameraRespawnPoint").position
		$Tween.interpolate_property(self, "position", null, final_pos, 2.0, 
									Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()



func _on_Tween_tween_completed(object, key):
	if object == self:
		$PauseTimer.start(2)
	elif object == top_gate and checkpoint_3_event_part == 1:
		checkpoint_3_event_part = 2
		$Tween.interpolate_property(top_gate, "position", null, Vector2(2248, 360), 6.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif object == top_gate and checkpoint_3_event_part == 2:
		checkpoint_3_event_part = 3
		$PauseTimer.start(3)
	elif object == bottom_gate and checkpoint_3_event_part == 3:
		checkpoint_3_event_part = 4
		$Tween.interpolate_property(bottom_gate, "position", null, Vector2(2248, -40), 6.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif object == bottom_gate and checkpoint_3_event_part == 4:
		checkpoint_3_event_part = 5
		$PauseTimer.start(0.5)




func _on_PauseTimer_timeout():
	match checkpoint_3_event_part:
		1:
			$Tween.interpolate_property(top_gate, "position", null, Vector2(2248, 56), 2.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		3:
			$Tween.interpolate_property(bottom_gate, "position", null, Vector2(2248, 264), 2.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		5:
			checkpoint_3_event_part = 6
			get_parent().get_node("Gate3").deactivate()
			get_parent().get_node("EnergyWire3").activate()
			$PauseTimer.start(2)
			active = true


