extends Sprite



export (float, 1000) var speed
export (float, 1000) var wave_length
export (float, 1000) var length_increase
export (float, 100) var amplitude
export (float, 200) var amplitude_decrease
export (int) var pulses



func _ready():
	get_material().set_shader_param("speed", speed)
	get_material().set_shader_param("wave_length", wave_length)
	get_material().set_shader_param("length_increase", length_increase)
	get_material().set_shader_param("amplitude", amplitude)
	get_material().set_shader_param("amplitude_decrease", amplitude_decrease)
	get_material().set_shader_param("pulses", pulses)
	get_material().set_shader_param("scale", get_viewport().size*2)
	scale = get_viewport().size

func _process(delta):
	get_material().set_shader_param("time", 5 - $Timer.time_left)

func _on_Timer_timeout():
	self.queue_free()
