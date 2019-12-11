extends Control
class_name BaseControlsConfigMenu

export (PackedScene) var button_model
export (ShortCut) var return_shortcut

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var control_handler = main.control_handler
onready var next_scene = null
onready var type = main.last_input_device
onready var YELLOW: String = "#f7ff00"
onready var RED: String = "#ff0000"
onready var PINK: String = "#ff4f78"
onready var pause_menu: bool

onready var map = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/Map")
onready var defaults_button = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Box/Defaults")
onready var model_button = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Model")
onready var change_button = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Change")
onready var return_button = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/OtherButtons/Return")

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
	match type:
		"Keyboard":
			change_button.text = "Controller Bindings"
		"Controller":
			change_button.text = "Keyboard Bindings"
	
	add_remove_model_buttton()
	defaults_button.connect("pressed", self, "_on_Defaults_pressed")
	map.get_children()[0].get_node("Button").grab_focus()



func add_popup(dialog_box: PopupDialog, menu: Control = self) -> void:
	dialog_box.menu = self
	add_child(dialog_box)

func _on_Defaults_pressed():
	InputMap.load_from_globals()

func _on_Return_pressed():
	if not pause_menu:
		main.change_scene(main.configuration_menu)
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().self_show()
		self.queue_free()

func _on_Change_pressed():
	match type:
		"Keyboard":
			type = "Controller"
			change_button.text = "Keyboard Bindings"
		"Controller":
			type = "Keyboard"
			change_button.text = "Controller Bindings"
	reload_buttons()

func _on_Model_pressed():
	match main.controller_layout:
		"Microsoft":
			main.controller_layout = "Sony"
		"Sony":
			main.controller_layout = "Nintendo"
		"Nintendo":
			main.controller_layout = "Microsoft"
	set_model()

func reload_buttons() -> void:
	for node in map.get_children():
		node.get_node("Button").type = type
	add_remove_model_buttton()

func add_remove_model_buttton() -> void:
	model_button.focus_neighbour_top = defaults_button.get_path()
	model_button.focus_neighbour_bottom = change_button.get_path()
	match type:
		"Controller":
			defaults_button.focus_neighbour_bottom = model_button.get_path()
			change_button.focus_neighbour_top = model_button.get_path()
			model_button.visible = true
		"Keyboard":
			defaults_button.focus_neighbour_bottom = change_button.get_path()
			change_button.focus_neighbour_top = defaults_button.get_path()
			model_button.visible = false
	set_model()

func set_model() -> void:
	model_button.text = main.controller_layout




