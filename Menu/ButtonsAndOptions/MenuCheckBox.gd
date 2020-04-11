extends HBoxContainer
class_name MenuCheckBox

signal toggle(button_pressed)

func _process(delta):
	if $CheckBox.disabled:
		$LabelBaseModel.set("custom_colors/font_color", Color("#7f7f76"))
		$CheckBox.set("custom_colors/font_color", Color("#7f7f76"))
	elif !$CheckBox.has_focus():
		$LabelBaseModel.set("custom_colors/font_color", Color("#f4f4e4"))
		$CheckBox.set("custom_colors/font_color", Color("#f4f4e4"))
	else:
		$LabelBaseModel.set("custom_colors/font_color", Color("#ff4f78"))
		$CheckBox.set("custom_colors/font_color", Color("#ff4f78"))
func _on_CheckBox_toggled(button_pressed):
	emit_signal("toggle",button_pressed)
