extends MarginContainer

export(PackedScene) var next_scene
export(PackedScene) var controls
export(PackedScene) var credits
export(ButtonGroup) var button_group

func _ready():
	$CenterContainer/CenterContainer/VBoxContainer3/VBoxContainer3/StartGame.grab_focus()

func _on_StartGame_pressed():
	self.get_parent().change_scene(next_scene)


func _on_Controls_pressed():
	self.get_parent().change_scene(controls)


func _on_Credits_pressed():
	self.get_parent().change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()



