extends CenterContainer

export (PackedScene) var button_model
export (ShortCut) var return_shortcut

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var control_handler = main.control_handler

onready var map = get_node("MarginContainer/MarginContainer/VBoxContainer/Map")
onready var defaults_button = get_node("MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Box/Defaults")
onready var model_button = get_node("MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Model")
onready var change_button = get_node("MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Change")
onready var return_button = get_node("MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Return")

func _ready():
	get_tree().paused = true
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		var button = button_model.instance()
		map.add_child(button)
		button.get_node("Button").parse(self, key, control_handler.actions_dictionary[key], control_handler, type)
		
		##################### Setting Buttons Neighbours ############################
		if (map.get_children().size() > 1):
			map.get_children()[-1].get_node("Button").focus_neighbour_top = map.get_children()[-2].get_node("Button").get_path()
			if (map.get_children().size() <= control_handler.actions_dictionary.keys().size()):
				map.get_children()[-2].get_node("Button").focus_neighbour_bottom = map.get_children()[-1].get_node("Button").get_path()
		############################################################################
		
	######################### The last button is neighbour of the top button and vice versa ###################
	return_button.focus_neighbour_bottom = map.get_children()[0].get_node("Button").get_path()
	map.get_children()[0].get_node("Button").focus_neighbour_top = return_button.get_path()
	defaults_button.focus_neighbour_top = map.get_children()[-1].get_node("Button").get_path()
	map.get_children()[-1].get_node("Button").focus_neighbour_bottom = defaults_button.get_path()
	#############################################################################################################
#	match type:
#		"Keyboard":
#			change_button.text = "Controller Bindings"
#		"Controller":
#			change_button.text = "Keyboard Bindings"
	
	add_remove_model_buttton()
	defaults_button.connect("pressed", self, "_on_Defaults_pressed")
	map.get_children()[0].get_node("Button").grab_focus()
