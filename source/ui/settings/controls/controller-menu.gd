extends Control

export(PackedScene) var dialog_box

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var pause_menu : bool = get_parent().pause_menu
onready var settings_menu: Node
onready var left_buttons: Array = $Center/Margin/Menu/Menu/Scheme/LeftList.get_children()
onready var right_buttons: Array = $Center/Margin/Menu/Menu/Scheme/RightList.get_children()

func _ready():
	parse_info()
	left_buttons[0].grab_focus()


func _on_ChangeLayout_pressed():
	get_parent().change_layout()

func _on_Return_pressed():
	settings_menu.quit()

func open_dialog_box(key: InputEventJoypadButton, key_name: String, button_node: ButtonModel,
						button_getter: ButtonGetter = main.control_handler) -> void:
	var dialog_box_instance = dialog_box.instance()
	dialog_box_instance.parent = self
	dialog_box_instance.key = key
	dialog_box_instance.key_name = key_name
	dialog_box_instance.control_handler = button_getter
	dialog_box_instance.button_node = button_node
	self.add_child(dialog_box_instance)

func _on_Defaults_pressed():
	settings_menu.load_defaults()
	for button in right_buttons + left_buttons:
		button.reload_button()

func parse_info() -> void:
	for button in left_buttons:
		if button is ControllerSettingsButton:
			button.menu = self
	for button in right_buttons:
		if button is ControllerSettingsButton:
			button.menu = self
	var key_name = main.control_handler.get_controller_button_name("ui_accept", "Microsoft")
	$Center/Margin/Menu/Menu/MenuAccept/Button.parse(self, "ui_accept", 
														main.control_handler.actions_dictionary["ui_accept"], main.control_handler, "Controller")
	key_name = main.control_handler.get_controller_button_name("ui_cancel", "Microsoft")
	$Center/Margin/Menu/Menu/MenuCancel/Button.parse(self, "ui_cancel", 
														main.control_handler.actions_dictionary["ui_cancel"], main.control_handler, "Controller")

func add_popup(dialog_popup: PopupDialog, menu: Control = self) -> void:
	dialog_popup.menu = menu
	add_child(dialog_popup)
