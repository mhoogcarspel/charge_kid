extends Popup

var type

onready var action: String
onready var control_handler: ButtonGetter
onready var configured: bool = false
onready var error: bool = false
onready var menu: Control

func _ready():
	popup_centered()
	menu.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS

func parse(action: String, control_handler: ButtonGetter, type:String):
	self.action = action
	self.control_handler = control_handler
	match type:
		"Keyboard":
			self.type = InputEventKey
		"Controller":
			self.type = InputEventJoypadButton

func _input(event):
	if control_handler.just_pressed(event) and not configured and not error:
		if event is type:
			
#			if !control_handler.find_another_action_with_same_key(action, event, type):
#				control_handler.change_key_binding(action, event, type)
#				configured = true
#			else:
#				error_message_1()
			
			
			var action2:String = control_handler.find_and_return_another_action_with_same_key(action , event, type)
			var key2: InputEvent = control_handler.get_type_button_list(action, type)[0]
			control_handler.swap_keys(action, key2, action2, event, type)
			configured = true
			
		else:
			error_message_2()
	elif error and $Timer.is_stopped():
		configured = true

func error_message_1() -> void:
	$LabelBaseModel.text = "Button already mapped,\n try another one."
	error = true
	$Timer.start()

func error_message_2() -> void:
	if type == InputEventKey:
		$LabelBaseModel.text = "Non keyboard button pressed,\n try another one."
	elif type == InputEventJoypadButton:
		$LabelBaseModel.text = "Non controller button pressed,\n try another one."
	error = true
	$Timer.start()

func _process(delta):
	if configured and !Input.is_action_pressed(action):
		self.exit()

func exit():
	menu.pause_mode = PAUSE_MODE_PROCESS
	self.pause_mode = PAUSE_MODE_INHERIT
	self.queue_free()