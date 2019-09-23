extends MarginContainer
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

func _ready():
	get_tree().paused = true
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		var button = button_model.instance()
		$VBoxContainer/Map.add_child(button)
		button.get_node("Button").parse(self, key, control_handler.actions_dictionary[key], control_handler, type)
		
		##################### Setting Buttons Neighbours ############################
		if ($VBoxContainer/Map.get_children().size() > 1):
			$VBoxContainer/Map.get_children()[-1].get_node("Button").focus_neighbour_top = $VBoxContainer/Map.get_children()[-2].get_node("Button").get_path()
			if ($VBoxContainer/Map.get_children().size() <= control_handler.actions_dictionary.keys().size()):
				$VBoxContainer/Map.get_children()[-2].get_node("Button").focus_neighbour_bottom = $VBoxContainer/Map.get_children()[-1].get_node("Button").get_path()
		############################################################################
		
	######################### The last button is neighbour of the top button and vice versa ###################
	$VBoxContainer/OtherButtons/Return.focus_neighbour_bottom = $VBoxContainer/Map.get_children()[0].get_node("Button").get_path()
	$VBoxContainer/Map.get_children()[0].get_node("Button").focus_neighbour_top = $VBoxContainer/OtherButtons/Return.get_path()
	$VBoxContainer/OtherButtons/Box/Defaults.focus_neighbour_top = $VBoxContainer/Map.get_children()[-1].get_node("Button").get_path()
	$VBoxContainer/Map.get_children()[-1].get_node("Button").focus_neighbour_bottom = $VBoxContainer/OtherButtons/Box/Defaults.get_path()
	#############################################################################################################
	match type:
		"Keyboard":
			$VBoxContainer/OtherButtons/Change.text = "Controller Bindings"
		"Controller":
			$VBoxContainer/OtherButtons/Change.text = "Keyboard Bindings"
	
	add_remove_model_buttton()
	$VBoxContainer/OtherButtons/Box/Defaults.connect("pressed", self, "_on_Defaults_pressed")
	$VBoxContainer/Map.get_children()[0].get_node("Button").grab_focus()



func add_popup(dialog_box: PopupDialog, menu: MarginContainer = self) -> void:
	dialog_box.menu = self
	add_child(dialog_box)

func _on_Defaults_pressed():
	InputMap.load_from_globals()

func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().get_node("CenterContainer/VBoxContainer/VBoxContainer/Resume").shortcut = return_shortcut
		self.queue_free()

func _on_Change_pressed():
	match type:
		"Keyboard":
			type = "Controller"
			$VBoxContainer/OtherButtons/Change.text = "Keyboard Bindings"
		"Controller":
			type = "Keyboard"
			$VBoxContainer/OtherButtons/Change.text = "Controller Bindings"
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
	for map in $VBoxContainer/Map.get_children():
		map.get_node("Button").type = type
	add_remove_model_buttton()

func add_remove_model_buttton() -> void:
	$VBoxContainer/OtherButtons/Model.focus_neighbour_top = $VBoxContainer/OtherButtons/Box/Defaults.get_path()
	$VBoxContainer/OtherButtons/Model.focus_neighbour_bottom = $VBoxContainer/OtherButtons/Change.get_path()
	match type:
		"Controller":
			$VBoxContainer/OtherButtons/Box/Defaults.focus_neighbour_bottom = $VBoxContainer/OtherButtons/Model.get_path()
			$VBoxContainer/OtherButtons/Change.focus_neighbour_top = $VBoxContainer/OtherButtons/Model.get_path()
			$VBoxContainer/OtherButtons/Model.visible = true
		"Keyboard":
			$VBoxContainer/OtherButtons/Box/Defaults.focus_neighbour_bottom = $VBoxContainer/OtherButtons/Change.get_path()
			$VBoxContainer/OtherButtons/Change.focus_neighbour_top = $VBoxContainer/OtherButtons/Box/Defaults.get_path()
			$VBoxContainer/OtherButtons/Model.visible = false
	set_model()

func set_model() -> void:
	$VBoxContainer/OtherButtons/Model.text = main.controller_layout