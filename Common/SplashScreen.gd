extends TextureRect

export (float) var transition_phase

func _process(_delta):
	get_material().set_shader_param("reveal", transition_phase)


