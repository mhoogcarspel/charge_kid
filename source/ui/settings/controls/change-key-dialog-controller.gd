extends Control

export(PackedScene) var button_model

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var parent: Node
onready var key: InputEventJoypadButton
onready var key_name: String
onready var control_handler: ButtonGetter
onready var buttons = $CenterContainer/MarginContainer/CenterContainer/VBoxContainer/VBoxContainer

var command_list: Array

func _ready():
	parent.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS
	for command in main.actions.keys():
		if command.begins_with("action_"):
			command_list.append(command)
	$CenterContainer/MarginContainer/CenterContainer/VBoxContainer/Label.text = "Choose a action for " + key_name
	
	
	var previous_button: ButtonModel
	for command in command_list:
		var button_model_instance = button_model.instance()
		button_model_instance.command = command
		button_model_instance.text = main.actions[command]
		buttons.add_child(button_model_instance)
		if previous_button != null:
			previous_button.focus_neighbour_bottom = button_model_instance.get_path()
			button_model_instance.focus_neighbour_top = previous_button.get_path()
		previous_button = button_model_instance
	previous_button.focus_neighbour_bottom = buttons.get_child(0).get_path()
	buttons.get_child(0).focus_neighbour_top = previous_button.get_path()
	buttons.get_child(0).grab_focus()
