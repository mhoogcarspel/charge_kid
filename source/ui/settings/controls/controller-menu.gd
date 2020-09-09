extends Control

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var pause_menu : bool = get_parent().pause_menu

func _ready():
	$Center/Margin/Menu/Menu/Scheme/LeftList.get_children()[0].grab_focus()


func _on_ChangeLayout_pressed():
	get_parent().change_layout()

func _on_Return_pressed():
	if not pause_menu:
		main.change_scene(main.settings_menu)
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().self_show()
		self.queue_free()
