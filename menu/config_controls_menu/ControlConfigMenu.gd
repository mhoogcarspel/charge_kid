extends MarginContainer

export(PackedScene) var button_model

onready var control_handler = get_parent().control_handler
onready var YELLOW:String = "#f7ff00"
onready var RED:String ="#ff0000"
onready var PINK:String = "#ff4f78"

func _ready():
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		var button = button_model.instance()
		button.parse(self, key, control_handler.actions_dictionary[key], control_handler)
		$CenterContainer/VBoxContainer/Map.add_child(button)
	
	$CenterContainer/VBoxContainer/Back/Button.focus_neighbour_bottom = $CenterContainer/VBoxContainer/Map.get_children()[0].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[0].focus_neighbour_top = $CenterContainer/VBoxContainer/Back/Button.get_path()
	$CenterContainer/VBoxContainer/Back/Button.focus_neighbour_top = $CenterContainer/VBoxContainer/Map.get_children()[-1].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[-1].focus_neighbour_bottom = $CenterContainer/VBoxContainer/Back/Button.get_path()
	
	$CenterContainer/VBoxContainer/Map.get_children()[0].grab_focus()

func add_popup(dialog_box: PopupDialog):
	$CenterContainer.add_child(dialog_box)

func _on_Button_pressed():
	var next_scene = load("res://menu/start_menu/StartMenu.tscn")
	get_parent().change_scene(next_scene)
