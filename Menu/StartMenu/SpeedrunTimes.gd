extends VBoxContainer



onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")



func _on_Timer_timeout():
	if save_file.progress["times"].size() > 0:
		self.visible = true
		$First.text = save_file.progress["times"][0]["string"]
		
		if save_file.progress["times"].size() >= 2:
			$Second.text = save_file.progress["times"][1]["string"]
		else:
			$Second.text = "---"
		
		if save_file.progress["times"].size() >= 3:
			$Third.text = save_file.progress["times"][2]["string"]
		else:
			$Third.text = "---"
		
		if save_file.progress["times"].size() >= 4:
			$Fourth.text = save_file.progress["times"][3]["string"]
		else:
			$Fourth.text = "---"
		
		if save_file.progress["times"].size() >= 5:
			$Fifth.text = save_file.progress["times"][4]["string"]
		else:
			$Fifth.text = "---"
