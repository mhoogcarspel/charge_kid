extends Control

export(PackedScene) var control_menu
onready var control_handler : ButtonGetter = get_tree().get_nodes_in_group("main")[0].control_handler

func _ready():
	$CenterContainer/VBoxContainer/VBoxContainer.get_children()[0].grab_focus()
	self.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = false
		self.queue_free()

func _on_Resume_pressed():
	get_tree().paused = false
	self.queue_free()


func _on_Controls_pressed():
	self.pause_mode = PAUSE_MODE_INHERIT
	var control_window = control_menu.instance()
	control_window.pause_menu = true
	self.add_child(control_window)

func refocus() -> void:
	$CenterContainer/VBoxContainer/VBoxContainer.get_children()[0].grab_focus()
	print("foi")
func _on_Quit_pressed():
	get_tree().quit()
