extends Control
class_name BaseControlsConfigMenu

export (PackedScene) var button_model
export (ShortCut) var return_shortcut
export (PackedScene) var keyboard_menu
export (PackedScene) var controller_menu

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var control_handler = main.control_handler
onready var next_scene = null
onready var mode = main.last_input_device
onready var YELLOW: String = "#f7ff00"
onready var RED: String = "#ff0000"
onready var PINK: String = "#ff4f78"
onready var pause_menu: bool

func _ready():
	match mode:
		"Keyboard":
			var keyboard_menu_instance = keyboard_menu.instance()
			self.add_child(keyboard_menu_instance)
		"Controller":
			var controller_menu_instance = controller_menu.instance()
			self.add_child(controller_menu_instance)
		_:
			pass


func add_popup(dialog_box: PopupDialog, menu: Control = self) -> void:
	dialog_box.menu = self
	add_child(dialog_box)

func _on_Model_pressed():
	match main.controller_layout:
		"Microsoft":
			main.controller_layout = "Sony"
		"Sony":
			main.controller_layout = "Nintendo"
		"Nintendo":
			main.controller_layout = "Microsoft"
#	set_model()

func change_layout() -> void:
	get_child(0).queue_free()
	match mode:
		"Keyboard":
			var controller_menu_instance = controller_menu.instance()
			self.add_child(controller_menu_instance)
			mode = "Controller"
		"Controller":
			var keyboard_menu_instance = keyboard_menu.instance()
			self.add_child(keyboard_menu_instance)
			mode = "Keyboard"
