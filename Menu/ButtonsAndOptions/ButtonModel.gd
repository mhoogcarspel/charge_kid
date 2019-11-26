extends MenuOption
class_name ButtonModel

func _process(_delta):
	if has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#535e69"))
	elif not has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#242a3b"))

func _on_ButtonModel_pressed():
	main.get_node("MenuAccept").play()
	if main.get_node("MenuNavigate").is_playing():
		main.get_node("MenuNavigate").stop()




