extends CanvasLayer

func _ready():
	get_tree().paused = true
	$ColorRect.visible = true
	$CenterContainer/Label.visible = true

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey and $PityTimer.is_stopped() and not event.is_echo() and event.is_pressed():
		_on_Timer_timeout()

func _on_Timer_timeout():
	get_tree().paused = false
	self.queue_free()



