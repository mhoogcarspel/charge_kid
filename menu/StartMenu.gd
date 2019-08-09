extends MarginContainer

export(PackedScene) var next_scene
export(PackedScene) var credits
export(ButtonGroup) var button_group

func _ready():
	button_group.get_buttons()[0].grab_focus()

func _on_StartGame_pressed():
	self.get_parent().change_scene(next_scene)


func _on_Credits_pressed():
	self.get_parent().change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()
