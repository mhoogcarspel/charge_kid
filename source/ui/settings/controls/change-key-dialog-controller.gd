extends Control

export(PackedScene) var button_model

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var parent: Node
onready var key: InputEventJoypadButton
onready var key_name: String
onready var control_handler: ButtonGetter

var command_list: Array

func _ready():
	parent.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS
	for command in main.actions.keys():
		if command.begins_with("action_"):
			command_list.append(command)
		pass
	print(command_list)
	$CenterContainer/MarginContainer/CenterContainer/VBoxContainer/Label.text = "Choose a action for " + key_name
