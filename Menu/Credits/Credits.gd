extends MarginContainer

onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	$HBoxContainer/VBoxContainer/Back.grab_focus()

func _on_Back_pressed():
	main.back_to_start()
