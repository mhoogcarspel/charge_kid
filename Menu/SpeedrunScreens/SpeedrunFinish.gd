extends CenterContainer



onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")
onready var speedrun_mode = main.get_node("SpeedrunMode")



func _ready():
	var result: Dictionary = speedrun_mode.time()
	
	### Saving the new time ########################################################
	if save_file.progress["times"] == null:
		save_file.progress["times"] = [result]
	else:
		
		var done = false
		for i in range(save_file.progress["times"].size()):
			if result["float"] < save_file.progress["times"][i]["float"] and not done:
				save_file.progress["times"].insert(i, result)
				done = true
		if not done:
			save_file.progress["times"].append(result)
		
		while save_file.progress["times"].size() > 5:
			save_file.progress["times"].pop_back()
	
	save_file.save_progress()
	################################################################################
	
	### Writing the results on the screen ##########################################
	$Box/RunTime/Time.text = result["string"]
	$Box/PastTimes/BestTime/Time.text = save_file.progress["times"][0]["string"]
	
	if save_file.progress["times"].size() >= 2:
		$Box/PastTimes/OtherTimes/Second.text = save_file.progress["times"][1]["string"]
	else:
		$Box/PastTimes/OtherTimes/Second.text = "---"
	
	if save_file.progress["times"].size() >= 3:
		$Box/PastTimes/OtherTimes/Third.text = save_file.progress["times"][2]["string"]
	else:
		$Box/PastTimes/OtherTimes/Third.text = "---"
	
	if save_file.progress["times"].size() >= 4:
		$Box/PastTimes/OtherTimes/Fourth.text = save_file.progress["times"][3]["string"]
	else:
		$Box/PastTimes/OtherTimes/Fourth.text = "---"
	
	if save_file.progress["times"].size() >= 5:
		$Box/PastTimes/OtherTimes/Fifth.text = save_file.progress["times"][4]["string"]
	else:
		$Box/PastTimes/OtherTimes/Fifth.text = "---"
	################################################################################



func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey and $Timer.is_stopped():
		main.back_to_start()
