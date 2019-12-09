extends ButtonModel
class_name MenuHSlider

export(float) var slide_time

onready var sound_control: SoundControl = get_tree().get_nodes_in_group("sound_control")[0]
onready var slider_timer: Timer = Timer.new()

func _ready():
	self.add_child(slider_timer)
	slider_timer.one_shot = true

func _process(delta):
	# Handling focus:
	if has_focus():
		if slider_timer.is_stopped() and main.get_node("MenuNavTimer").is_stopped():
			if main.control_handler.get_directional_input().x == 1:
				$HSlider.value += $HSlider.step
			elif main.control_handler.get_directional_input().x == -1:
				$HSlider.value -= $HSlider.step
			slider_timer.start(slide_time)
		if main.control_handler.get_directional_input() == Vector2.ZERO and not slider_timer.is_stopped():
			slider_timer.stop()
