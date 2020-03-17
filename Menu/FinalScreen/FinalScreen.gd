extends MarginContainer

var main
export (PackedScene) var credits



func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		main = get_tree().get_nodes_in_group("main")[0]
		var save_file = main.get_node("SaveFileHandler")
		save_file.progress["end"] = true
		save_file.save_progress()
	else:
		main = null

func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and $Timer.is_stopped():
		if main == null:
			get_tree().quit()
		else:
			main.change_scene(credits)




