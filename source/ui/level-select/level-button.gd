extends ButtonModel


onready var save_file = main.get_node("SaveFileHandler")

var level: int
var pause_menu: bool



func _ready():
	self.text = "Level " + String(level)

func _on_LevelButton_pressed():
	if level < 0:
		main.change_scene(save_file.secret_levels[abs(level) - 1])
		return
	main.change_scene(save_file.levels[level - 1])


