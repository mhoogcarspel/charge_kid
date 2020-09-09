extends Control

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var pause_menu : bool = get_parent().pause_menu
onready var settings_menu: Node

func _ready():
	$Center/Margin/Menu/Menu/Scheme/LeftList.get_children()[0].grab_focus()


func _on_ChangeLayout_pressed():
	get_parent().change_layout()

func _on_Return_pressed():
	settings_menu.quit()


func _on_Defaults_pressed():
	settings_menu.load_defaults()
