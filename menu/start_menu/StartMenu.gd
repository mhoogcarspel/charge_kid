extends MarginContainer

export(PackedScene) var next_scene
export(PackedScene) var credits
export(ButtonGroup) var button_group
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	$CenterContainer/CenterContainer/VBoxContainer3/VBoxContainer3/StartGame.grab_focus()

func _on_StartGame_pressed():
	self.get_parent().change_scene(next_scene)


func _on_Controls_pressed():
	if main.is_using_keyboard():
		self.get_parent().change_scene(main.keyboard_controls)
	elif main.is_using_controller():
		self.get_parent().change_scene(main.controller_controls)


func _on_Credits_pressed():
	self.get_parent().change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()



