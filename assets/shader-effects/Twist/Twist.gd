extends Node2D

export (float) var radius;
export (float) var torsion;

onready var shader = $Shader.get_material()

func _process(delta):
	shader.set_shader_param("radius", radius)
	shader.set_shader_param("torsion", torsion)
	shader.set_shader_param("scale", get_viewport().size)
	$Shader.scale = get_viewport().size/2