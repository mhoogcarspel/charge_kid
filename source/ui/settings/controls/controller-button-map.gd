extends ButtonModel



export(PackedScene) var dialog_popup

onready var control_handler: ButtonGetter
onready var type: String
onready var model: String
onready var key: String
onready var action: String
onready var menu: Node



func parse(menu_0: Node, key_0: String, action_0: String, control_handler_0: ButtonGetter, type_0: String = ""):
	self.menu = menu_0
	self.key = key_0
	self.action  = action_0
	self.control_handler = control_handler_0
	self.type = type_0



func _on_ButtonModel_pressed():
	._on_ButtonModel_pressed()
	var popup = dialog_popup.instance()
	popup.parse(key, control_handler, type)
	menu.add_popup(popup)



func _process(_delta):
	self.text = action + ": " + control_handler.get_controller_button_name(key,
																main.controller_layout)


