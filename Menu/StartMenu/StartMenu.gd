extends MarginContainer

export (PackedScene) var game_scene
export (PackedScene) var level_select
export (PackedScene) var credits
export (PackedScene) var button_model
export (PackedScene) var speedrun_start
export (ButtonGroup) var button_group

export (PackedScene) var tear_shader
export (float) var tear_frequency

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")



func _ready():
	main.get_node("BackgroundAndMusicHandler/Background").playing = true
	main.get_node("BackgroundAndMusicHandler").zero_all_bgm()
	
	var button_list = $CenterContainer/VBoxContainer/Menu
	save_file.load_progress()
	var progress = save_file.progress
	
	if progress["levels"] > 0:
		var new_game_button: ButtonModel = button_list.get_node("NewGame")
		var quit_button: ButtonModel = button_list.get_node("Quit")
		
		var level_select_button: ButtonModel = button_model.instance()
		level_select_button.text = "Level Select"
		button_list.add_child(level_select_button)
		button_list.move_child(level_select_button, 0)
		level_select_button.connect("pressed", self, "_on_LevelSelect_pressed")
		level_select_button.focus_neighbour_bottom = new_game_button.get_path()
		level_select_button.focus_neighbour_top = quit_button.get_path()
		new_game_button.focus_neighbour_top = level_select_button.get_path()
		quit_button.focus_neighbour_bottom = level_select_button.get_path()
		
		var next_button: ButtonModel = button_model.instance()
		button_list.add_child(next_button)
		button_list.move_child(next_button, 0)
		next_button.focus_neighbour_bottom = level_select_button.get_path()
		next_button.focus_neighbour_top = quit_button.get_path()
		level_select_button.focus_neighbour_top = next_button.get_path()
		quit_button.focus_neighbour_bottom = next_button.get_path()
		
		if progress["end"] == false:
			next_button.text = "Continue"
			next_button.connect("pressed", self, "_on_Continue_pressed")
		else:
			next_button.text = "Speedrun"
			next_button.connect("pressed", self, "_on_Speedrun_pressed")
		
	button_list.get_children()[0].grab_focus()
	get_tree().paused = true
	
	if main.get_node("SpeedrunMode").is_active():
		main.get_node("SpeedrunMode").time()
	
	for i in range(50):
		generate_tear(10)



func _physics_process(delta):
	var rng = randi()%1000
	if rng > 1000 - tear_frequency/delta:
		generate_tear(tear_frequency)
	
	if tear_frequency > 0.5:
		tear_frequency = clamp(tear_frequency - delta*10, 0.5, 10.0)



func generate_tear(multiplier: float = 1.0):
	var tear = tear_shader.instance()
	tear.duration = 0.1 + float(randi()%11)/100
	tear.tear_distance = float(randi()%101)*multiplier/10000
	tear.tear_size = float(randi()%201)/1000
	tear.position.x = get_viewport().size.x/2
	tear.position.y = randi()%(get_viewport().size.y as int)
	self.add_child(tear)



func _on_Continue_pressed():
	main.change_scene(save_file.levels[save_file.progress["levels"] - 1])


func _on_Speedrun_pressed():
	main.get_node("SpeedrunMode").ready()
	main.change_scene(speedrun_start)


func _on_LevelSelect_pressed():
	main.change_scene(level_select)


func _on_StartGame_pressed():
	save_file.erase_progress()
	main.change_scene(save_file.levels[0])


func _on_Settings_pressed():
	main.change_scene(main.settings_menu)


func _on_Credits_pressed():
	main.change_scene(credits)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Timer_timeout():
	$CenterContainer/VBoxContainer/Title/PinkParticles.emitting = true
