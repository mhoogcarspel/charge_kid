extends Node
class_name SaveHandler


export (Array, PackedScene) var levels

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
		if !check_file_integrity(file_string, progress, file.get_path()):
			make_backup_file(file.get_path(),file_string, progress)
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

func check_file_integrity(file_string: String, model: Dictionary, file_path: String) -> bool:
	var error_message = validate_json(file_string)
	
	if error_message:
		print(error_message)
		print("ERROR:" + file_path + " file is not on Json format")
		return false
	var file_json = parse_json(file_string)
	
	if file_json.keys().size() != model.keys().size():
		print("ERROR: key numbers different in" + file_path)
		return false
	
	for i in range(0, file_json.keys().size()):
		if not file_json.keys()[i] in model.keys():
			print("ERROR:" + file_json.keys()[i] + " on " + file_path + " is not a valid key")
			return false
		if not model.keys()[i] in file_json.keys():
			print("ERROR:" + model.keys()[i] + " not in " + file_path)
			return false
	
	for key in file_json:
		if typeof(file_json[key]) != typeof(model[key]):
			print("ERROR: Variable " + key + " in " + file_path + " of wrong type")
			return false
	return true

func make_backup_file(file_path:String, file_string: String, model:Dictionary) -> void:
	var file : = File.new()
	file.open(file_path+".backup", File.WRITE)
	file.store_line(file_string)
	file.open(file_path, File.WRITE)
	file.store_line(to_json(model))
	file.close()
	print(file_path + " backup saved as " + file_path + ".backup and file rewritten to standard")
