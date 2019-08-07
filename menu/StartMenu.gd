extends MarginContainer

export(PackedScene) var next_scene
export(PackedScene) var Credits

func _on_StartGame_pressed():
	self.get_parent().change_scene(next_scene)


func _on_Credits_pressed():
	self.get_parent().change_scene(Credits)


func _on_Quit_pressed():
	get_tree().quit()
