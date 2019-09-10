extends MarginContainer

export (PackedScene) var button_model
export (ShortCut) var return_shortcut

onready var control_handler = get_tree().get_nodes_in_group("main")[0].control_handler
onready var next_scene = null
onready var type = "Controller"
onready var controller_model = "Microsoft"
onready var YELLOW: String = "#f7ff00"
onready var RED: String = "#ff0000"
onready var PINK: String = "#ff4f78"
onready var pause_menu: bool
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		var button = button_model.instance()
		button.parse(self, key, control_handler.actions_dictionary[key], control_handler)
		button.type = type
		$CenterContainer/VBoxContainer/Map.add_child(button)
		
		
		##################### Setting Buttons Neighbours ############################
		if ($CenterContainer/VBoxContainer/Map.get_children().size() > 1):
			$CenterContainer/VBoxContainer/Map.get_children()[-1].focus_neighbour_top = $CenterContainer/VBoxContainer/Map.get_children()[-2].get_path()
			if ($CenterContainer/VBoxContainer/Map.get_children().size() < control_handler.actions_dictionary.keys().size()):
				$CenterContainer/VBoxContainer/Map.get_children()[-2].focus_neighbour_bottom = $CenterContainer/VBoxContainer/Map.get_children()[-1].get_path()
		############################################################################
		
	######################### The last button is neighbour of the top button and vice versa ###################
	$CenterContainer/VBoxContainer/OtherButtons/Return.focus_neighbour_bottom = $CenterContainer/VBoxContainer/Map.get_children()[0].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[0].focus_neighbour_top = $CenterContainer/VBoxContainer/OtherButtons/Return.get_path()
	$CenterContainer/VBoxContainer/OtherButtons/Model.focus_neighbour_top = $CenterContainer/VBoxContainer/Map.get_children()[-1].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[-1].focus_neighbour_bottom = $CenterContainer/VBoxContainer/OtherButtons/Model.get_path()
	#############################################################################################################
	
	$CenterContainer/VBoxContainer/Map.get_children()[0].grab_focus()

func _process(delta):
	$CenterContainer/VBoxContainer/OtherButtons/Model.text = "Layout: " + controller_model

func add_popup(dialog_box: PopupDialog, menu: MarginContainer = self) -> void:
	dialog_box.menu = self
	$CenterContainer.add_child(dialog_box)

func _on_Return_pressed():
	if not pause_menu:
		get_parent().back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().get_node("CenterContainer/VBoxContainer/VBoxContainer/Resume").shortcut = return_shortcut
		self.queue_free()

func _on_Keyboard_pressed():
	var keyboard_window = main.keyboard_controls.instance()
	keyboard_window.pause_menu = pause_menu
	get_parent().add_child(keyboard_window)

func _on_Model_pressed():
	match controller_model:
		"Microsoft":
			controller_model = "Sony"
		"Sony":
			controller_model = "Nintendo"
		"Nintendo":
			controller_model = "Microsoft"


