extends Object
class_name ButtonGetter

func _init(actions_list: PoolStringArray):
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