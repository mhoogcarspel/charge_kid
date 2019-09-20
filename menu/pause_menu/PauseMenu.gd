extends Control

export(PackedScene) var control_menu
onready var control_handler : ButtonGetter = get_tree().get_nodes_in_group("main")[0].control_handler
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	$CenterContainer/VBoxContainer/VBoxContainer.get_children()[0].grab_focus()



func _on_Resume_pressed():
	get_tree().paused = false
	self.queue_free()

func _on_RestartLevel_pressed():
	get_tree().paused = false
	self.queue_free()
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		main.change_scene(main.actual_scene)
	else:
		get_tree().reload_current_scene()

func _on_Controls_pressed():
	self.pause_mode = PAUSE_MODE_STOP
	$CenterContainer/VBoxContainer/VBoxContainer/Resume.shortcut = null
	var control_window = control_menu.instance()
	control_window.pause_menu = true
	self.add_child(control_window)



func _on_Quit_pressed():
	get_tree().quit()



func refocus() -> void:
	$CenterContainer/VBoxContainer/VBoxContainer.get_children()[0].grab_focus()








