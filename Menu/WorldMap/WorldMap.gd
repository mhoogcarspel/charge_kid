extends Control
class_name WorldMap

onready var level_nodes_list:Array = $CenterContainer/VBoxContainer.get_children()
onready var main : Node

var continue_game:bool
var open_all: bool

func _ready():
	for level_node in level_nodes_list:
		level_node.world_map = self
	if continue_game:
		load_game()

func delete_save() -> void:
	pass

func new_game() -> void:
	pass

func save_game() -> void:
	var save:= File.new()
	save.open(main.save_name + ".save", File.WRITE)
	var levels_save:Dictionary = {}
	for level in level_nodes_list:
		levels_save[level.path] = level.call("save")
	save.store_line(to_json(levels_save))
	save.close()

func load_game() -> void:
	var save_game = File.new()
	if not save_game.file_exists(main.save_name + ".save"):
		save_game()
	save_game.open(main.save_name + ".save", File.READ)
	var levels_save = parse_json(save_game.get_line())
	for level_path in levels_save.keys():
		print(level_path)
		var level = get_node(level_path)
		for variable in levels_save[level_path].keys():
			level.set(variable, levels_save[level_path][variable])




