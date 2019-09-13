extends CPUParticles2D

func _ready():
	emitting = true
	for child in get_children():
		child.emitting = true

func _process(_delta):
	var is_over = true
	if not emitting:
		for child in get_children():
			if child.emitting:
				is_over = false
		if is_over:
			queue_free()



