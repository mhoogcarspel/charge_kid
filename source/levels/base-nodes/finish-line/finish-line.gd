extends Area2D



func _on_FinishLine_body_entered(body):
	if body.is_in_group("player") and get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var level = get_tree().get_nodes_in_group("level")[0].level
		AchievementsAndStatsObserver.set_stat("main_levels_finished", level)
		
		if level == 10:
			AchievementsAndStatsObserver.indicate_achievement_progress("finish_main_game", level, 17)
			
		var next_level = main.get_node("SaveFileHandler").levels[level]
		main.change_scene(next_level)

