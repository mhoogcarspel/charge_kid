extends MarginContainer

export(PackedScene) var Game
export(PackedScene) var Credits

func _on_StartGame_pressed():
	self.get_parent().change_scene(Game)


func _on_Credits_pressed():
	self.get_parent().change_scene(Credits)


func _on_Quit_pressed():
	get_tree().quit()
