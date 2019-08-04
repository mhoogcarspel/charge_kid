extends MarginContainer

export(PackedScene) var Game
export(PackedScene) var Credits

func _on_StartGame_pressed():
	print("Start Game")


func _on_Credits_pressed():
	print("Credits")


func _on_Quit_pressed():
	get_tree().quit()
