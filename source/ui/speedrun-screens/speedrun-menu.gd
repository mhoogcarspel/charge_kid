extends Control

export (PackedScene) var speedrun_start
export (ShortCut) var return_shortcut



onready var main: Node
onready var save_file: Node
onready var pause_menu: bool



func _ready():
	get_tree().paused = true
	if not get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
		save_file = main.get_node("SaveFileHandler")
		
		var secret_percent = $CenterContainer/MarginContainer/MarginContainer/Menu/Options/SecretPercent
		var checkbox = $CenterContainer/MarginContainer/MarginContainer/Menu/Options/FasterSidescrollers/CheckBox
		checkbox.pressed = save_file.progress["faster_sidescrollers"]
		secret_percent.disabled = not save_file.progress["secrets"][5]
	refocus()



func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().self_show()
		get_parent().refocus()
		self.queue_free()



func _on_Any_pressed():
	main.get_node("SpeedrunMode").category = "Any%"
	main.get_node("SpeedrunMode").ready()
	main.change_scene(speedrun_start)

func _on_Secret_pressed():
	main.get_node("SpeedrunMode").category = "Secret%"
	main.get_node("SpeedrunMode").ready()
	main.change_scene(speedrun_start)



func _on_FasterSidescrollers_toggle(button_pressed):
	save_file.progress["faster_sidescrollers"] = button_pressed
	save_file.save_progress()



func _on_Erase_pressed():
	self_hide()
	self.add_child(prepare_scene(main.erase_times_menu))



func prepare_scene(settings_menu: PackedScene) -> Control:
	self.pause_mode = PAUSE_MODE_STOP
	var settings_window = settings_menu.instance()
	if pause_menu:
		settings_window.pause_menu = true
	return settings_window



func refocus() -> void:
	$CenterContainer/MarginContainer/MarginContainer/Menu/Options/AnyPercent.grab_focus()

func self_hide() -> void:
	$CenterContainer.hide()

func self_show() -> void:
	$CenterContainer.show()





