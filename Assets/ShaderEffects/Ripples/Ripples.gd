extends Node2D



export (float, 1000) var speed
export (float, 1000) var wave_length
export (float, 1000) var length_increase
export (float, 100) var amplitude
export (float, 200) var amplitude_decrease
export (int) var pulses

onready var shader = $Shader.get_material()



func _ready():
	shader.set_shader_param("speed", speed)
	shader.set_shader_param("wave_length", wave_length)
	shader.set_shader_param("length_increase", length_increase)
	shader.set_shader_param("amplitude", amplitude)
	shader.set_shader_param("amplitude_decrease", amplitude_decrease)
	shader.set_shader_param("pulses", pulses)
	shader.set_shader_param("scale", get_viewport().size*2)
	$Shader.scale = get_viewport().size

func _process(delta):
	shader.set_shader_param("time", 5 - $Timer.time_left)

func _on_Timer_timeout():
	self.queue_free()
