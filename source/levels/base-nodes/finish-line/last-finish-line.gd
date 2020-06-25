extends Area2D

export (PackedScene) var end_scene
export (PackedScene) var speedrun_finish

func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().get_nodes_in_group("main").size() > 0:
			var main = get_tree().get_nodes_in_group("main")[0]
			
			############## Achievment Stuff ############################
			var level: int = get_tree().get_nodes_in_group("level")[0].level
			AchievementsAndStatsObserver.set_stat("main_levels_finished", level)
			if level == 10:
				AchievementsAndStatsObserver.indicate_achievement_progress("beat_the_game", level, 17)
			############################################################
			
			var speedrun_mode = main.get_node("SpeedrunMode")
			if speedrun_mode.is_active() and speedrun_mode.category == "times":
				main.change_scene(speedrun_finish)
			elif not speedrun_mode.is_active():
				main.change_scene(end_scene)
		else:
			get_tree().change_scene_to(end_scene)



