extends Object
class_name ButtonGetter

onready var gamepad_map: Dictionary
onready var actions_dictionary: Dictionary
onready var actions_list: Array



func _init(actions_dictionary: Dictionary):
	
	self.actions_dictionary = actions_dictionary.duplicate()
	self.actions_list = actions_dictionary.keys().duplicate()
	
	self.gamepad_map = {
	"DPAD Up": ["DPad Up", "DPad Up", "DPad Up"],
	"DPAD Down": ["DPad Down", "DPad Down", "DPad Down"],
	"DPAD Left": ["DPad Left", "DPad Left", "DPad Left"],
	"DPAD Right": ["DPad Right", "DPad Right", "DPad Right"],
	
	"Face Button Bottom": ["A", "Cross", "B"],
	"Face Button Right": ["B", "Circle", "A"],
	"Face Button Left": ["X", "Square", "Y"],
	"Face Button Top": ["Y", "Triangle", "X"],
	
	"L": ["LB", "L1", "L"],
	"R": ["RB", "R1", "R"],
	"L2": ["LT", "L2", "LZ"],
	"R2": ["RT", "R2", "RZ"],
	
	"L3": ["L-Stick", "L3", "L-Stick"],
	"R3": ["R-Stick", "R3", "R-Stick"],
	
	"Start": ["Start", "Start", "+"],
	"Select": ["Select", "Select", "-"],
	}

func erase_all_actions() -> void:
	for action in actions_list:
			InputMap.erase_action(action)

func change_key_binding(action: String, key: InputEvent, type) -> bool:
	var button_list: Array
	button_list = get_type_button_list(action, type)
	if button_list.size() >= 1:
		for old_event in button_list:
			InputMap.action_erase_event(action, old_event)
	
	InputMap.action_add_event(action, key)
	return true

func find_and_erase_another_action_with_same_key(exception: String, key: InputEvent):
	for action in actions_list:
		if action != exception && key_in_list(key, InputMap.get_action_list(action)):
			for event in InputMap.get_action_list(action):
				InputMap.action_erase_event(action, event)

func find_another_action_with_same_key(exception: String, key: InputEvent, type) -> bool:
	for action in actions_list:
		if action != exception && key_in_list(key, get_type_button_list(action, type)):
			return true
	return false

func key_in_list(key:InputEvent, list: Array) -> bool:
	if key is InputEventKey:
		for action in list:
			if action.as_text() == key.as_text():
				return true
	elif key is InputEventJoypadButton:
		for action in list:
			if Input.get_joy_button_string(key.button_index) == Input.get_joy_button_string(action.button_index):
				return true
	return false


# Functions that get button names. Each action needs to have two actions, the first must always be keyboard
# and the second must always be joypad.

func get_type_button_list(action: String, type) -> Array:
	if !InputMap.get_action_list(action).empty():
		var button_list: Array = []
		for button in InputMap.get_action_list(action):
			if button is type:
				button_list.push_back(button)
		return button_list
	return []

func get_keyboard_key_name(action: String) -> String:
	var button_string: String
	
	if InputMap.get_action_list(action).size() == 0:
		return ""
	
	button_string = get_type_button_list(action, InputEventKey)[0].as_text()
	return button_string

func get_controller_button_name(action: String, model: String = "Microsoft") -> String:
	var button_string: String
	var button_list: Array = get_type_button_list(action, InputEventJoypadButton)
	
	if button_list.empty():
		return ""
	
	button_string = Input.get_joy_button_string(get_type_button_list(action, InputEventJoypadButton)[0].button_index)
	
	match model:
		"Microsoft":
			button_string = self.gamepad_map[button_string][0]
		"Sony":
			button_string = self.gamepad_map[button_string][1]
		"Nintendo":
			button_string = self.gamepad_map[button_string][2]
	
	return button_string



func is_keyboard_or_gamepad_key(event: InputEvent) -> bool:
	return event is InputEventKey or event is InputEventJoypadButton

func just_pressed(event:InputEvent) -> bool:
	return event.is_pressed() and !event.is_echo()

func equalize_equivalent_keys(action1: String, action2: String):
	for event in InputMap.get_action_list(action2):
		InputMap.action_erase_event(action2, event)
	for event in InputMap.get_action_list(action1):
		InputMap.action_add_event(action2, event)



### THUMBSTICK INPUTS #############################################################
const DEADZONE: float = 0.4

func get_l_stick(device = 0) -> Vector2:
	var input: Vector2 = Vector2.ZERO
	input.x = Input.get_joy_axis(device, JOY_ANALOG_LX)
	input.y = Input.get_joy_axis(device, JOY_ANALOG_LY)
	return input

func get_r_stick(device = 0) -> Vector2:
	var input: Vector2 = Vector2.ZERO
	input.x = Input.get_joy_axis(device, JOY_ANALOG_RX)
	input.y = Input.get_joy_axis(device, JOY_ANALOG_RY)
	return input

func get_l_stick_directional(device = 0) -> Vector2:
	var stick: Vector2 = get_l_stick(device)
	var direction: Vector2 = Vector2.ZERO
	
	if stick.length_squared() >= DEADZONE*DEADZONE:
		var angle: float = stick.angle()
		
		# Getting Y axis direction:
		if angle > PI/8 and angle < 7*PI/8:
			direction.y = 1
		elif angle < -PI/8 and angle > -7*PI/8:
			direction.y = -1
		
		# Getting X axis direction:
		if angle < 3*PI/8 and angle > -3*PI/8:
			direction.x = 1
		elif angle > 5*PI/8 or angle < -5*PI/8:
			direction.x = -1
			
	return direction

func get_r_stick_directional(device = 0) -> Vector2:
	var stick: Vector2 = get_r_stick(device)
	var direction: Vector2 = Vector2.ZERO
	
	if stick.length_squared() >= DEADZONE*DEADZONE:
		var angle: float = stick.angle()
		
		# Getting Y axis direction:
		if angle > PI/8 and angle < 7*PI/8:
			direction.y = 1
		elif angle < -PI/8 and angle > -7*PI/8:
			direction.y = -1
		
		# Getting X axis direction:
		if angle < 3*PI/8 and angle > -3*PI/8:
			direction.x = 1
		elif angle > 5*PI/8 or angle < -5*PI/8:
			direction.x = -1
	
	return direction
###################################################################################



### DIRECTIONAL INPUTS ############################################################
enum {L_STICK, R_STICK, BOTH_STICKS, NONE}

func get_directional_input(device = 0, get_from_sticks = L_STICK) -> Vector2:
	# Getting from sticks:
	var analog: Vector2 = Vector2.ZERO
	if get_from_sticks == R_STICK or get_from_sticks == BOTH_STICKS:
		analog = get_r_stick_directional(device)
	elif get_from_sticks == L_STICK or get_from_sticks == BOTH_STICKS:
		analog = get_l_stick_directional(device)
	
	# Getting from D-Pad or keyboard:
	var digital: Vector2 = Vector2.ZERO
	digital.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	digital.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if digital == Vector2.ZERO:
		return analog
	else:
		return digital
###################################################################################




