extends MarginContainer

export var game: PackedScene
export var control_remap: PackedScene

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
	var file = File.new()
	file.open("buttons_map", File.WRITE)
	for action in actions_dictionary.keys():
		var label = LabelBaseModel.new()
		$VBoxContainer/Keymap/Actions.add_child(label)
		label.text = actions_dictionary[action] + ":"
		var label2 = LabelBaseModel.new()
		$VBoxContainer/Keymap/Buttons.add_child(label2)
		label2.set("custom_colors/font_color", Color(PINK))
		label2.text = control_handler.get_button_name(action)
		file.store_string(InputMap.get_action_list(action)[0].as_text() + ":action = " + action + ":" + control_handler.get_button_name(action) + '\n')
	file.close()
	
	var label = LabelBaseModel.new()
	$VBoxContainer/HBoxContainer.add_child(label)
	label.text = "\nThis is your control map.\n Press " + control_handler.get_button_name("ui_jump") + " to confirm or " + control_handler.get_button_name("ui_shoot") + " to remap"


func _input(event):
	if event.is_action("ui_jump"):
		var next_scene = game
		get_parent().change_scene(next_scene)
	elif event.is_action("ui_shoot"):
		var next_scene = load("res://menu/ControlConfig.tscn")
		get_parent().change_scene(next_scene)