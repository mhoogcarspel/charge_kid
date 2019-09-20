extends MarginContainer

export(PackedScene) var next_scene
export(PackedScene) var credits
export(ButtonGroup) var button_group
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	$CenterContainer/CenterContainer/VBoxContainer3/VBoxContainer3/StartGame.grab_focus()
	get_tree().paused = true

func _on_StartGame_pressed():
	main.change_scene(next_scene)


func _on_Controls_pressed():
	main.change_scene(main.controls_menu)


func _on_Credits_pressed():
	main.change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()



