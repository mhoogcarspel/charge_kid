extends CanvasLayer

export (String, MULTILINE) var opening_text
export (bool) var active

func _ready():
	if active:
		get_tree().paused = true
		$ColorRect.visible = true
		$CenterContainer/Label.visible = true
		$CenterContainer/Label.text = opening_text
	else:
		get_tree().paused = false
		self.queue_free()

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey and $PityTimer.is_stopped() and not event.is_echo() and event.is_pressed():
		_on_Timer_timeout()

func _on_Timer_timeout():
	get_tree().paused = false
	self.queue_free()



