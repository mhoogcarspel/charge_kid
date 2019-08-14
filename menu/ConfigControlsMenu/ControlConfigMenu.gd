extends MarginContainer

export(PackedScene) var button_model

onready var control_handler = get_parent().control_handler
onready var YELLOW:String = "#f7ff00"
onready var RED:String ="#ff0000"
onready var PINK:String = "#ff4f78"
onready var actions_dictionary: Dictionary = {
	"ui_jump": "Jump",
	"ui_shoot": "Shoot",
	"ui_boost": "Boost",
	"ui_left": "Left",
	"ui_right": "Right",
	"ui_up": "Up",
	"ui_down": "Down"
	}

func _ready():
	for key in actions_dictionary:
		var button = button_model.instance()
		button.parse(key, actions_dictionary[key], control_handler)
		$CenterContainer/VBoxContainer.add_child(button)