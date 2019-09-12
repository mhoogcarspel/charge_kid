extends Popup

var type

onready var action: String
onready var control_handler: ButtonGetter
onready var configured: bool = false
onready var menu: MarginContainer

func _ready():
	popup_centered()
	menu.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS
	if !menu.pause_menu:
		get_tree().paused = true

func parse(action: String, control_handler: ButtonGetter, type:String):
	self.action = action
	self.control_handler = control_handler
	match type:
		"Keyboard":
			self.type = InputEventKey
		"Controller":
			self.type = InputEventJoypadButton

func _input(event):
	if control_handler.just_pressed(event) and !configured and event is type:
		if !control_handler.find_another_action_with_same_key(action, event, type):
			control_handler.change_key_binding(action, event, type)
			configured = true
		else:
			$LabelBaseModel.text = error_message()

func error_message() -> String:
	return ("ERROR: button already mapped,\n try another button")

func _process(delta):
	if configured and !Input.is_action_pressed(action):
		self.exit()

func exit():
	menu.pause_mode = PAUSE_MODE_PROCESS
	self.pause_mode = PAUSE_MODE_INHERIT
	if !menu.pause_menu:
		get_tree().paused = false
	self.queue_free()