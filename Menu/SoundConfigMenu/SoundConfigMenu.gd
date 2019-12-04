tool
extends Control

export(NodePath) var options_path
export(int) var slider_size setget set_slider_size

func set_slider_size(new_value: int) -> void:
	slider_size = new_value
	for option in get_node(options_path).get_children():
		if option is MenuHSlider:
			option.set("margin_left", -slider_size/2)
			option.set("margin_right", slider_size/2 + slider_size%2)
	pass

func _ready():
	pass