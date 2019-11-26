extends MenuOption
class_name ButtonModel

onready var base_menu_option = preload("BaseMenuOption.gd").new()
#onready var main = get_tree().get_nodes_in_group("main")[0]



func _process(_delta):
	# Handling focus:
#	if has_focus():
#		if $Timer.is_stopped() and main.get_node("MenuNavTimer").is_stopped():
#			if main.control_handler.get_directional_input().y == 1:
#				get_node(focus_neighbour_bottom).grab_focus()
#			elif main.control_handler.get_directional_input().y == -1:
#				get_node(focus_neighbour_top).grab_focus()
#			elif main.control_handler.get_directional_input().x == 1:
#				get_node(focus_neighbour_right).grab_focus()
#			elif main.control_handler.get_directional_input().x == -1:
#				get_node(focus_neighbour_left).grab_focus()
#		if main.control_handler.get_directional_input() == Vector2.ZERO and not $Timer.is_stopped():
#			$Timer.stop()

	# Changing colors for a disabled button with focus:
	if has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#535e69"))
	elif not has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#242a3b"))

#func _on_ButtonModel_focus_entered():
#	$Timer.start()


### HANDLING NAVIGATION SFX ###################################################
#func _on_ButtonModel_focus_exited():
#	if not main.get_node("MenuAccept").is_playing():
#		main.get_node("MenuNavigate").play()

func _on_ButtonModel_pressed():
	main.get_node("MenuAccept").play()
	if main.get_node("MenuNavigate").is_playing():
		main.get_node("MenuNavigate").stop()
###############################################################################



