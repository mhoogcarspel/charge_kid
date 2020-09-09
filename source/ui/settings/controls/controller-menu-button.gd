extends ButtonModel

export(int) var device
export(int) var index

onready var button_getter: ButtonGetter = main.control_handler

var input_event: InputEventJoypadButton
var action: String

func _ready():
	input_event = InputEventJoypadButton.new()
	input_event.button_index = index
	input_event.device = device
