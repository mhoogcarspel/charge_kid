extends MarginContainer

export var game: PackedScene
export var control_remap: PackedScene

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
	for action in actions_dictionary.keys():
		var label = LabelBaseModel.new()
		$VBoxContainer/Keymap/Actions.add_child(label)
		label.text = actions_dictionary[action] + ":"
		var label2 = LabelBaseModel.new()
		$VBoxContainer/Keymap/Buttons.add_child(label2)
		label2.set("custom_colors/font_color", Color(PINK))
		label2.text = InputMap.get_action_list(action)[0].as_text()
	
	var label = LabelBaseModel.new()
	$VBoxContainer/HBoxContainer.add_child(label)
	label.text = "\nThis is your control map.\n Press " + InputMap.get_action_list("ui_jump")[0].as_text() + " to confirm or " + InputMap.get_action_list("ui_shoot")[0].as_text() + " to remap"

func _input(event):
	if event.is_action("ui_jump"):
		var next_scene = game
		get_parent().change_scene(next_scene)
	elif event.is_action("ui_shoot"):
		var next_scene = load("res://menu/ControlConfig.tscn")
		get_parent().change_scene(next_scene)