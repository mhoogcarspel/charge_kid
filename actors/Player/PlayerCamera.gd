extends Camera2D


onready var shake_amplitude: float = 0

func _process(delta):
	if shake_amplitude > 0:
#		shake_amplitude = clamp()
		pass



func screen_shake(magnitude: float) -> void:
	shake_amplitude = magnitude


