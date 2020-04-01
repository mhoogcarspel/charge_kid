extends Node
class_name SaveHandler


export (Array, PackedScene) var levels

onready var file_handler:FileHandler = get_parent().get_node("FileHandler")

var progress: Dictionary = {
	"levels": 0.0,
	"end": false
}


func save_progress() -> void:
	var file = File.new()
	file.open("save_progress.save", File.WRITE)
	file.store_line(to_json(progress))
	file.close()

func load_progress() -> void:
	var file = File.new()
	if file.file_exists("save_progress.save"):
		file.open("save_progress.save", File.READ)
		var file_string: String = file.get_line()
		if !file_handler.check_file_integrity(file_string, progress, file.get_path()):
			file_handler.make_backup_file(file.get_path(),file_string, progress)
			file.close()
			return
		progress = parse_json(file_string)

func erase_progress() -> void:
	var file = File.new()
	file.open("save_progress.save", File.WRITE)
	progress["levels"] = 0
	progress["end"] = false
	file.store_line(to_json(progress))
	file.close()
