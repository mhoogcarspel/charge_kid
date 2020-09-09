extends Control

onready var main = get_tree().get_nodes_in_group("main")
onready var parent: Node
onready var key: InputEventJoypadButton
onready var key_name: String
onready var control_handler: ButtonGetter

var command_list: Array

func _ready():
	parent.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS
	for command in main.actions.keys():
		if command.begin_with("action_"):
			command_list.append(command)
		pass
	$Title.text = "Choose a action for " + key_name
