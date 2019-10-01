extends CPUParticles2D



var gate = get_parent().get_parent()

func _process(delta):
	if gate.is_active() and  $Timer.is_stopped() and not Engine.editor_hint:
		if gate.direction == "Vertical":
			gravity = Vector2(0,60)
		elif gate.direction == "Horizontal":
			gravity = Vector2(-60,0)
		$Timer.start((randi()%20)/10 + 2)
		emitting = true
