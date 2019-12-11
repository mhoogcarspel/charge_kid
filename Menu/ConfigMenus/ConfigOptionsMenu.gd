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
		get_parent().self_show()
		get_parent().refocus()
		self.queue_free()


func _on_SoundOptions_pressed():
	self_hide()
	self.add_child(prepare_scene(main.sound_menu))


func _on_Controls_pressed():
	self.add_child(prepare_scene(main.controls_menu))

func prepare_scene(settings_menu: PackedScene) -> Control:
	self.pause_mode = PAUSE_MODE_STOP
	var settings_window = settings_menu.instance()
	if pause_menu:
		settings_window.pause_menu = true
	return settings_window

func refocus() -> void:
	$MarginContainer/Options/SoundOptions.grab_focus()

func self_hide() -> void:
	$MarginContainer.hide()

func self_show() -> void:
	$MarginContainer.show()