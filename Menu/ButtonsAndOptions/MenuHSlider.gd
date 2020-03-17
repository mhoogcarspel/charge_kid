extends ButtonModel
class_name MenuHSlider

export(float) var hold_slide_time
export(float) var slide_time

onready var sound_control: SoundControl = get_tree().get_nodes_in_group("sound_control")[0]
onready var on_hold: bool = false


func _process(delta):
	# Handling focus:
	if has_focus():
		var directional_input: Vector2 = main.control_handler.get_directional_input()
		if $SliderTimer.is_stopped():
			if directional_input.length() > 0:
				if directional_input.x == 1:
					$HSlider.value += $HSlider.step
				elif directional_input.x == -1:
					$HSlider.value -= $HSlider.step
				if !on_hold:
					$SliderTimer.start(hold_slide_time)
					on_hold = true
				else:
					$SliderTimer.start(slide_time)
		if directional_input == Vector2.ZERO:
			on_hold = false
			if not $SliderTimer.is_stopped():
				$SliderTimer.stop()
