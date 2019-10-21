extends Camera2D



onready var dissipation: float = 0.0
onready var shake_amplitude: float = 0.0
onready var shake_direction: int = 1

func _physics_process(delta):
	if shake_amplitude > 0:
# warning-ignore:narrowing_conversion
		limit_left = -shake_amplitude
		if get_tree().get_nodes_in_group("player").size() > 0:
			limit_right = get_tree().get_nodes_in_group("player")[0].level_length + shake_amplitude
		
		shake_amplitude = clamp(shake_amplitude - delta*dissipation, 0, 1000)
		
		if shake_amplitude > 4:
			offset.x += 4*delta*dissipation*shake_direction
			while abs(offset.x) > shake_amplitude:
				if offset.x > shake_amplitude:
					offset.x = shake_amplitude - (offset.x - shake_amplitude)
					shake_direction = -1
				elif offset.x < -shake_amplitude:
					offset.x = -shake_amplitude + (-offset.x - shake_amplitude)
					shake_direction = 1
		else:
			shake_amplitude = 0
			limit_left = 0
			if get_tree().get_nodes_in_group("player").size() > 0:
				limit_right = get_tree().get_nodes_in_group("player")[0].level_length
		
	elif offset.x != 0:
		offset.x = 0.0

func screen_shake(magnitude: float) -> void:
	shake_direction = 1
	shake_amplitude = magnitude
	dissipation = magnitude*4


