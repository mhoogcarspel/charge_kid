extends Node



export (Array, PackedScene) var levels

var progress: Dictionary = {
	"levels": 0,
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
		if !check_file_integrity(file_string):
			file.open("save_progress_backup.save", File.WRITE)
			file.store_line(file_string)
			erase_progress()
			print("ERROR: save file unreadable.")
			print("A backup has been saved as save_progress_backup.save and the game progress reseted")
		file.close()

func erase_progress() -> void:
	var file = File.new()
	file.open("save_progress.save", File.WRITE)
	progress["levels"] = 0
	progress["end"] = false
	file.store_line(to_json(progress))
	file.close()

func check_file_integrity(file_string: String) -> bool:
	var error_message = validate_json(file_string)
	
	if error_message:
		print(error_message)
		print("ERROR: Save file is not on Json format")
		return false
	progress = parse_json(file_string)
	
	if progress.keys().size() > 2:
		print("ERROR: More itens than needed in save_progress.save")
		return false
	elif !("levels" in progress.keys()) or !("end" in progress.keys()):
		print("ERROR: key missing in progress.save")
		return false
	elif !(progress["levels"] is float):
		print("ERROR: levels value is not a number")
		return false
	elif !(progress["end"] is bool):
		print("ERROR: levels value is not a int")
		return false
	return true
	
