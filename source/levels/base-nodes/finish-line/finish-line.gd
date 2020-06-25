extends Area2D



func _on_FinishLine_body_entered(body):
	if body.is_in_group("player") and get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var speedrun_mode = main.get_node("SpeedrunMode")
		var level_scene = get_tree().get_nodes_in_group("level")[0]
		var level = level_scene.level
		AchievementsAndStatsObserver.set_stat("main_levels_finished", level)
		
		if level == 17:
			if not level_scene.player_died:
				AchievementsAndStatsObserver.set_achievement("clutch")
		
		
		if level == 18:
			AchievementsAndStatsObserver.set_achievement("beat_the_secret")
			if not level_scene.player_died:
				AchievementsAndStatsObserver.set_achievement("secret_clutch")
		
		var speedrun_mode = main.get_node("SpeedrunMode")
		if speedrun_mode.is_active() and speedrun_mode.category == "secret_times":
			if level == 3 or level == 7 or level == 11 or level == 13 or level == 17:
				return

		var next_level = main.get_node("SaveFileHandler").levels[level]
		main.change_scene(next_level)

