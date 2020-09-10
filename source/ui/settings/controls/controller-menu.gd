extends Control

export(PackedScene) var dialog_box

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var pause_menu : bool = get_parent().pause_menu
onready var settings_menu: Node

func _ready():
	parse_info()
	$Center/Margin/Menu/Menu/Scheme/LeftList.get_children()[0].grab_focus()


func _on_ChangeLayout_pressed():
	get_parent().change_layout()

func _on_Return_pressed():
	settings_menu.quit()

func open_dialog_box(key: InputEventJoypadButton, key_name: String,
						button_getter: ButtonGetter = main.control_handler) -> void:
	var dialog_box_instance = dialog_box.instance()
	dialog_box_instance.parent = self
	dialog_box_instance.key = key
	dialog_box_instance.key_name = key_name
	self.add_child(dialog_box_instance)

func _on_Defaults_pressed():
	settings_menu.load_defaults()

func parse_info() -> void:
	var left_buttons: Array = $Center/Margin/Menu/Menu/Scheme/LeftList.get_children()
	var right_buttons: Array = $Center/Margin/Menu/Menu/Scheme/RightList.get_children()
	for button in left_buttons:
		if button is ControllerSettingsButton:
			button.menu = self
	for button in right_buttons:
		if button is ControllerSettingsButton:
			button.menu = self
