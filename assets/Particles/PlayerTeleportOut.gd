extends CPUParticles2D

func _ready():
	for vec in emission_points:
		emission_normals.append(-vec.normalized())
	emitting = true
	one_shot = true

func _process(_delta):
	if not emitting:
		queue_free()


