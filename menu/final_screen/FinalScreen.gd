extends MarginContainer

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		get_parent().change_scene(load("res://menu/start_menu/StartMenu.tres"))