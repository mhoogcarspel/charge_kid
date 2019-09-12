extends Button

export(PackedScene) var dialog_popup

onready var control_handler: ButtonGetter
onready var type: String
onready var model: String
onready var key: String
onready var action: String
onready var menu: MarginContainer

onready var white: Color = Color("#f6f6e6")
onready var pink: Color = Color("#ff4c7b")

func parse(menu: MarginContainer, key:String, action: String, control_handler:ButtonGetter):
	self.menu = menu
	self.key = key
	self.action  = action
	self.control_handler = control_handler

func _process(delta):
	if type == "Keyboard":
		get_parent().get_node("Action").text = action + " : "
		get_parent().get_node("Key").text = control_handler.get_keyboard_key_name(key)
	elif type == "Controller":
		model = get_parent().get_parent().get_parent().get_parent().controller_model
		get_parent().get_node("Action").text = action + " : "
		get_parent().get_node("Key").text = control_handler.get_controller_button_name(key, model)
	
	if self.has_focus():
		get_parent().get_node("Action").set("custom_colors/font_color", pink)
		get_parent().get_node("Key").set("custom_colors/font_color", pink)
	else:
		get_parent().get_node("Action").set("custom_colors/font_color", white)
		get_parent().get_node("Key").set("custom_colors/font_color", white)
	

func _on_BaseControlConfigButton_pressed():
	var popup = dialog_popup.instance()
	popup.parse(key, control_handler)
	menu.add_popup(popup)
