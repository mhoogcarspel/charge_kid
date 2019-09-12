extends Button
class_name ButtonModel



func _process(_delta):
	if has_focus() and disabled:
		set("custom_colors/font_color_disabled", Color("#4d5762"))
	elif not has_focus() and disabled:
		set("custom_colors/font_color_disabled", Color("#1f232f"))


