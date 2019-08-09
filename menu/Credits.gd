extends MarginContainer

func _ready():
	$HBoxContainer/VBoxContainer/Back.grab_focus()

func _on_Back_pressed():
	get_parent().back_to_start()
