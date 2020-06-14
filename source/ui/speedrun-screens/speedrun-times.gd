extends MarginContainer

export (String, "times", "secret_times") var category

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")



func _on_Timer_timeout():
	if category == "times" or save_file.progress["secrets"][5] == true:
		if save_file.progress[category].size() >= 1:
			$Times/First.text = save_file.progress[category][0]["string"]
		else:
			$Times/First.text = "---"
		
		if save_file.progress[category].size() >= 2:
			$Times/Second.text = save_file.progress[category][1]["string"]
		else:
			$Times/Second.text = "---"
		
		if save_file.progress[category].size() >= 3:
			$Times/Third.text = save_file.progress[category][2]["string"]
		else:
			$Times/Third.text = "---"
		
		if save_file.progress[category].size() >= 4:
			$Times/Fourth.text = save_file.progress[category][3]["string"]
		else:
			$Times/Fourth.text = "---"
		
		if save_file.progress[category].size() >= 5:
			$Times/Fifth.text = save_file.progress[category][4]["string"]
		else:
			$Times/Fifth.text = "---"
	else:
		self.visible = false


