extends Button
class_name ButtonModel

onready var main = get_tree().get_nodes_in_group("main")[0]



func _process(_delta):
	if has_focus() and disabled:
		set("custom_colors/font_color_disabled", Color("#4d5762"))
	elif not has_focus() and disabled:
		set("custom_colors/font_color_disabled", Color("#1f232f"))

func _on_ButtonModel_focus_exited():
	if not main.get_node("MenuAccept").is_playing():
		main.get_node("MenuNavigate").play()


func _on_ButtonModel_pressed():
	main.get_node("MenuAccept").play()
	if main.get_node("MenuNavigate").is_playing():
		main.get_node("MenuNavigate").stop()




