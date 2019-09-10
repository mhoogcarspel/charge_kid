extends Button

export(PackedScene) var dialog_popup

onready var control_handler: ButtonGetter
onready var type: String
onready var model: String
onready var key: String
onready var action: String
onready var menu: MarginContainer

func parse(menu: MarginContainer, key:String, action: String, control_handler:ButtonGetter):
	self.menu = menu
	self.key = key
	self.action  = action
	self.control_handler = control_handler

func _process(delta):
	if type == "Keyboard":
		self.text = action + " : " + control_handler.get_keyboard_key_name(key)
	elif type == "Controller":
		model = get_parent().get_parent().get_parent().get_parent().controller_model
		self.text = action + " : " + control_handler.get_controller_button_name(key, model)

func _on_BaseControlConfigButton_pressed():
	var popup = dialog_popup.instance()
	popup.parse(key, control_handler)
	menu.add_popup(popup)
