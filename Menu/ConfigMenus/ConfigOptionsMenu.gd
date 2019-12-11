extends Control

export(ShortCut) var return_shortcut

onready var main: Node
onready var pause_menu: bool

func _ready():
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
	$MarginContainer/Options/SoundOptions.grab_focus()


func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().menu.get_node("Resume").shortcut = return_shortcut
		self.queue_free()


func _on_SoundOptions_pressed():
	main.change_scene(main.sound_menu)


func _on_Controls_pressed():
	main.change_scene(main.controls_menu)
