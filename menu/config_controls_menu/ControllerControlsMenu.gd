extends MarginContainer

export (PackedScene) var button_model
export (ShortCut) var return_shortcut

onready var control_handler = get_tree().get_nodes_in_group("main")[0].control_handler
onready var next_scene = null
onready var type = "Controller"
onready var YELLOW: String = "#f7ff00"
onready var RED: String = "#ff0000"
onready var PINK: String = "#ff4f78"
onready var pause_menu: bool
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		var button = button_model.instance()
		$VBoxContainer/Map.add_child(button)
		button.get_node("Button").parse(self, key, control_handler.actions_dictionary[key], control_handler)
		button.get_node("Button").type = type
		
		##################### Setting Buttons Neighbours ############################
		if ($VBoxContainer/Map.get_children().size() > 1):
			$VBoxContainer/Map.get_children()[-1].get_node("Button").focus_neighbour_top = $VBoxContainer/Map.get_children()[-2].get_node("Button").get_path()
			if ($VBoxContainer/Map.get_children().size() < control_handler.actions_dictionary.keys().size()):
				$VBoxContainer/Map.get_children()[-2].get_node("Button").focus_neighbour_bottom = $VBoxContainer/Map.get_children()[-1].get_node("Button").get_path()
		############################################################################
		
	######################### The last button is neighbour of the top button and vice versa ###################
	$VBoxContainer/OtherButtons/Return.focus_neighbour_bottom = $VBoxContainer/Map.get_children()[0].get_node("Button").get_path()
	$VBoxContainer/Map.get_children()[0].get_node("Button").focus_neighbour_top = $VBoxContainer/OtherButtons/Return.get_path()
	$VBoxContainer/OtherButtons/Box/Defaults.focus_neighbour_top = $VBoxContainer/Map.get_children()[-1].get_node("Button").get_path()
	$VBoxContainer/Map.get_children()[-1].get_node("Button").focus_neighbour_bottom = $VBoxContainer/OtherButtons/Box/Defaults.get_path()
	#############################################################################################################
	
	$VBoxContainer/Map.get_children()[0].get_node("Button").grab_focus()

func _process(delta):
	$VBoxContainer/OtherButtons/Model.text = "Layout: " + main.controller_layout

func add_popup(dialog_box: PopupDialog, menu: MarginContainer = self) -> void:
	dialog_box.menu = self
	add_child(dialog_box)

func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().get_node("CenterContainer/VBoxContainer/VBoxContainer/Resume").shortcut = return_shortcut
		self.queue_free()

func _on_Keyboard_pressed():
	var keyboard_window = main.keyboard_controls.instance()
	keyboard_window.pause_menu = pause_menu
	get_parent().add_child(keyboard_window)
	self.queue_free()

func _on_Model_pressed():
	match main.controller_layout:
		"Microsoft":
			main.controller_layout = "Sony"
		"Sony":
			main.controller_layout = "Nintendo"
		"Nintendo":
			main.controller_layout = "Microsoft"




func _on_Defaults_pressed():
	InputMap.load_from_globals()
