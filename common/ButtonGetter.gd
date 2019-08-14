extends Object
class_name ButtonGetter

onready var gamepad_map: Dictionary
onready var actions_list: Array
func print_map():
	for key in gamepad_map.keys():
		print(key)

func _init(actions_list: Array = []):
	
	self.actions_list = actions_list.duplicate()
	
	self.gamepad_map = {
	"Face Button Bottom":"Gamepad button A",
	"Face Button Top":"Gamepad button Y",
	"Face Button Left":"Gamepad button B",
	"Face Button Right":"Gamepad button X"
	}
	print_map()

func reinit(actions_list: PoolStringArray = []):
	if actions_list.size() > 0:
		erase_all_actions()
	for action in actions_list:
		InputMap.add_action(action)

func erase_all_actions() -> void:
	for action in InputMap.get_actions():
		if action != "ui_cancel":
			InputMap.erase_action(action)

func change_key_binding(action: String, key: InputEvent) -> bool:
	if InputMap.get_action_list(action):
		for old_event in InputMap.get_action_list(action):
			InputMap.action_erase_event(action, old_event)
	
	if !InputMap.get_action_list(action).empty():
		print("Failed to erase keys on ButtonGetter.gd -> InputMap.action_erase_event(action, event)")
		return false
	
	InputMap.action_add_event(action, key)
	
	return true

func find_and_erase_another_action_with_same_key(exception: String, key: InputEvent) -> bool:
	for action in InputMap.get_actions():
		if action != exception && key in InputMap.get_action_list(action):
			InputMap.action_erase_event(action, key)
		
		if InputMap.get_action_list(action):
			print("Failed to erase keys on ButtonGetter.gd -> InputMap.action_erase_event(action, key)")
			return false
	
	return true

func find_another_action_with_same_key(exception: String, key: InputEvent) -> bool:
	for action in InputMap.get_actions():
		if action != exception && key_in_list(key, InputMap.get_action_list(action)):
			return true
	return false

func key_in_list(key:InputEvent, list: Array) -> bool:
	for action in list:
		if action.as_text() == key.as_text():
			return true
	return false

func get_button_name(action: String) -> String:
	var button_string: String
	
	if InputMap.get_action_list(action)[0] is InputEventJoypadButton:
		button_string = Input.get_joy_button_string(InputMap.get_action_list(action)[0].button_index)
		if button_string in self.gamepad_map.keys():
			button_string = self.gamepad_map[button_string]
		
	else:
		button_string = InputMap.get_action_list(action)[0].as_text()
	
	return button_string