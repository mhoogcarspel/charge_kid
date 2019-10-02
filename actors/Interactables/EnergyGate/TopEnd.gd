extends StaticBody2D



onready var gate = get_parent().get_parent()

func _process(delta):
	if not Engine.editor_hint:
		if gate.is_active():
			$AnimationPlayer.play("On")
		else:
			$AnimationPlayer.play("Off")



