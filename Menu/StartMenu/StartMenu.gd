extends MarginContainer

export(PackedScene) var game_scene
export(PackedScene) var world_map
export(PackedScene) var credits
export(PackedScene) var button_model
export(ButtonGroup) var button_group
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	var button_list = $CenterContainer/CenterContainer/VBoxContainer3/VBoxContainer3
	var save_file: = File.new()
	if save_file.file_exists(main.save_name + ".save"):
		var continue_button: ButtonModel = button_model.instance()
		continue_button.text = "Continue"
		var new_game_button: ButtonModel = button_list.get_node("NewGame")
		var quit_button: ButtonModel = button_list.get_node("Quit")
		button_list.add_child(continue_button)
		button_list.move_child(continue_button, 0)
		
		continue_button.connect("pressed", self, "_on_Continue_pressed")
		
		###########Reassign neighbours####################
		continue_button.focus_neighbour_bottom = new_game_button.get_path()
		new_game_button.focus_neighbour_top = continue_button.get_path()
		continue_button.focus_neighbour_top = quit_button.get_path()
		quit_button.focus_neighbour_bottom = continue_button.get_path()
		###################################################
		
	button_list.get_children()[0].grab_focus()
	get_tree().paused = true

func _on_Continue_pressed():
	main.go_to_world_map().continue_game = true


func _on_StartGame_pressed():
	main.go_to_world_map()


func _on_Controls_pressed():
	main.change_scene(main.controls_menu)


func _on_Credits_pressed():
	main.change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()



