extends Popup

export(PackedScene) var control_menu
onready var control_handler : ButtonGetter = get_parent().control_handler

func _ready():
	print(control_handler.actions_dictionary)
	self.margin_right = OS.window_size.x/2
	self.margin_bottom = OS.window_size.y/2
	$CenterContainer/VBoxContainer/VBoxContainer.get_children()[0].grab_focus()
	popup()
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
	pass


func _on_Quit_pressed():
	get_tree().quit()
