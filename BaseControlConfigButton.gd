extends Button

onready var control_handler: ButtonGetter
onready var key: String
onready var action: String

func parse(key:String, action: String, control_handler:ButtonGetter):
	self.key = key
	self.action  = action
	self.control_handler = control_handler

func _process(delta):
	self.text = action + " : " + control_handler.get_button_name(key)

func _on_BaseControlConfigButton_pressed():
	print("Fooooooi")
