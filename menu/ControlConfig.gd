extends MarginContainer

export var next_scene:PackedScene

onready var actions: Dictionary = {
	"ui_jump": "Jump",
	"ui_shoot": "Shoot",
	"ui_boost": "Boost",
	"ui_left": "Left",
	"ui_right": "Right",
	"ui_up": "Up",
	"ui_down": "Down"
	}

onready var control_handler = get_parent().control_handler
onready var controls_iterator: int = 0
onready var configuring: bool = false
onready var key_pressed:InputEventKey = null

func _ready():
	$VBoxContainer/HBoxContainer/MessageControls.text = " Time to decide your controls. \n We recommend zxc + arrows or equivalent. \n Press any key when you're ready."

func _input(event):
	if event is InputEventKey || event is InputEventJoypadButton and just_pressed(event):
		if configuring:
			if !control_handler.find_another_action_with_same_key(actions.keys()[controls_iterator], event):
				$VBoxContainer/Error.text = ""
				control_handler.change_key_binding(actions.keys()[controls_iterator], event)
				controls_iterator += 1
				if controls_iterator == actions.size():
					get_parent().change_scene(next_scene)
			else:
				$VBoxContainer/Error.text = "\nERROR: You already assigned that key to another action,\n try another key."
		else:
			configuring = true
		if controls_iterator < actions.size():
			$VBoxContainer/HBoxContainer/MessageControls.text = "Press a key to " + actions[actions.keys()[controls_iterator]]

func just_pressed(event: InputEvent) -> bool:
	return event.is_pressed() and !event.is_echo()