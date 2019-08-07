extends Label
class_name LabelBaseModel

func _ready():
	var new_font = DynamicFont.new()
	var new_data = DynamicFontData.new()
	new_data.font_path = "res://assets/Fonts/codeman38_press-start-2p/PressStart2P.ttf"
	new_font.font_data = new_data
	self.set("custom_fonts/font", new_font)