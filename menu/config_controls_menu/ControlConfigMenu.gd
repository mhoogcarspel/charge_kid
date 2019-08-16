extends MarginContainer

export(PackedScene) var button_model

onready var control_handler = get_parent().control_handler
onready var next_scene = null
onready var YELLOW:String = "#f7ff00"
onready var RED:String ="#ff0000"
onready var PINK:String = "#ff4f78"
onready var pause_menu: bool = false

func _ready():
	var previous_button: Button = null
	for key in control_handler.actions_dictionary.keys():
		print(key)
		var button = button_model.instance()
		button.parse(self, key, control_handler.actions_dictionary[key], control_handler)
		$CenterContainer/VBoxContainer/Map.add_child(button)
	
	$CenterContainer/VBoxContainer/Back/Button.focus_neighbour_bottom = $CenterContainer/VBoxContainer/Map.get_children()[0].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[0].focus_neighbour_top = $CenterContainer/VBoxContainer/Back/Button.get_path()
	$CenterContainer/VBoxContainer/Back/Button.focus_neighbour_top = $CenterContainer/VBoxContainer/Map.get_children()[-1].get_path()
	$CenterContainer/VBoxContainer/Map.get_children()[-1].focus_neighbour_bottom = $CenterContainer/VBoxContainer/Back/Button.get_path()
	
	$CenterContainer/VBoxContainer/Map.get_children()[0].grab_focus()

func add_popup(dialog_box: PopupDialog) -> void:
	$CenterContainer.add_child(dialog_box)

func _on_Button_pressed():
	if not pause_menu:
		get_parent().back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		self.queue_free()
		pass
