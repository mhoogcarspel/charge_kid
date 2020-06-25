extends Area2D

export (PackedScene) var end_scene
export (PackedScene) var speedrun_finish

func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().get_nodes_in_group("main").size() > 0:
			var main = get_tree().get_nodes_in_group("main")[0]
			
			############## Achievment Stuff ############################
			var level_scene = get_tree().get_nodes_in_group("level")[0]
			var level: int = level_scene.level
			AchievementsAndStatsObserver.set_stat("main_levels_finished", level)
			if level == 17:
				if not level_scene.player_died:
					AchievementsAndStatsObserver.set_achievement("clutch")
			############################################################
			
			var speedrun_mode = main.get_node("SpeedrunMode")
			if speedrun_mode.is_active() and speedrun_mode.category == "times":
				main.change_scene(speedrun_finish)
			elif not speedrun_mode.is_active():
				main.change_scene(end_scene)
		else:
			get_tree().change_scene_to(end_scene)



