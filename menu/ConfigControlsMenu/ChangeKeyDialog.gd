extends Popup

onready var action: String
onready var control_handler: ButtonGetter

func _ready():
	popup_centered()
	self.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true

func parse(action: String, control_handler: ButtonGetter):
	self.action = action
	self.control_handler = control_handler

func _input(event):
	if control_handler.is_keyboard_or_gamepad_key(event) and control_handler.just_pressed(event):
		control_handler.find_and_erase_another_action_with_same_key(action, event)
		control_handler.change_key_binding(action, event)
			
		self.exit()

func display_error():
	pass

func exit():
	get_tree().paused = false
	self.pause_mode = PAUSE_MODE_INHERIT
	self.queue_free()