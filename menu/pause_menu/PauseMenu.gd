extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
