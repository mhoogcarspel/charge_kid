extends Button

export(PackedScene) var dialog_popup

onready var control_handler: ButtonGetter
onready var key: String
onready var action: String
onready var menu: MarginContainer

func parse(menu: MarginContainer, key:String, action: String, control_handler:ButtonGetter):
	self.menu = menu
	self.key = key
	self.action  = action
	self.control_handler = control_handler

func _process(delta):
	self.text = action + " : " + control_handler.get_button_name(key)

func _on_BaseControlConfigButton_pressed():
	var popup = dialog_popup.instance()
	popup.parse(action, control_handler)
	menu.add_popup(popup)
