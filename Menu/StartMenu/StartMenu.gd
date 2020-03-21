extends MarginContainer

export (PackedScene) var game_scene
export (PackedScene) var level_select
export (PackedScene) var credits
export (PackedScene) var button_model
export (ButtonGroup) var button_group
onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")

func _ready():
	var button_list = $CenterContainer/VBoxContainer3/VBoxContainer3
	save_file.load_progress()
	var progress = save_file.progress
	
	if progress["levels"] > 0:
		var new_game_button: ButtonModel = button_list.get_node("NewGame")
		var quit_button: ButtonModel = button_list.get_node("Quit")
		
		var level_select_button: ButtonModel = button_model.instance()
		level_select_button.text = "Level Select"
		button_list.add_child(level_select_button)
		button_list.move_child(level_select_button, 0)
		level_select_button.connect("pressed", self, "_on_LevelSelect_pressed")
		level_select_button.focus_neighbour_bottom = new_game_button.get_path()
		level_select_button.focus_neighbour_top = quit_button.get_path()
		new_game_button.focus_neighbour_top = level_select_button.get_path()
		quit_button.focus_neighbour_bottom = level_select_button.get_path()
		
		if progress["end"] == false:
			var continue_button: ButtonModel = button_model.instance()
			continue_button.text = "Continue"
			button_list.add_child(continue_button)
			button_list.move_child(continue_button, 0)
			continue_button.connect("pressed", self, "_on_Continue_pressed")
			continue_button.focus_neighbour_bottom = level_select_button.get_path()
			continue_button.focus_neighbour_top = quit_button.get_path()
			level_select_button.focus_neighbour_top = continue_button.get_path()
			quit_button.focus_neighbour_bottom = continue_button.get_path()
		
	button_list.get_children()[0].grab_focus()
	get_tree().paused = true


func _on_Continue_pressed():
	main.change_scene(save_file.levels[save_file.progress["levels"] - 1])


func _on_LevelSelect_pressed():
	main.change_scene(level_select)


func _on_StartGame_pressed():
	save_file.erase_progress()
	main.change_scene(save_file.levels[0])


func _on_Settings_pressed():
	main.change_scene(main.settings_menu)


func _on_Credits_pressed():
	main.change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()



