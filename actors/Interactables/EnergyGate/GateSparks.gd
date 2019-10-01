extends CPUParticles2D



onready var gate = get_parent().get_parent()

func _process(delta):
	if gate.is_active() and  $Timer.is_stopped():
		if gate.direction == "Vertical":
			gravity = Vector2(0,60)
		elif gate.direction == "Horizontal":
			gravity = Vector2(-60,0)
		var time: float = randi()%20
		time = time/10 + 2
		$Timer.start(time)
		emitting = true
