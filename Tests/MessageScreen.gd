tool
extends NinePatchRect
class_name MessageBox

export(String, MULTILINE) var screen_text
onready var on_screen_text: String = ""
onready var on_screen_text_with_cursor = on_screen_text + "_"

func _process(delta):
	if Engine.editor_hint:
		$LabelBaseModel.set("text", screen_text)
	$LabelBaseModel.text = on_screen_text_with_cursor

func _on_BlinkTimer_timeout():
	if on_screen_text_with_cursor.ends_with("_"):
		on_screen_text_with_cursor = on_screen_text
	else:
		on_screen_text_with_cursor = on_screen_text + "_"


func _on_TextOnScreenTimer_timeout():
	var subtext: String = ""
	for character in screen_text:
		subtext += character
		if !on_screen_text.begins_with(subtext):
			on_screen_text += character
			return
