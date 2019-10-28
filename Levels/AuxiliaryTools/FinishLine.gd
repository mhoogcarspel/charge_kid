extends Area2D
class_name FinishLine

var main

export(PackedScene) var next_stage
export(String, "All", "Up", "Down", "Left", "Right") var direction

onready var level: BaseLevel = get_parent()



func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().get_nodes_in_group("main").size() > 0:
			main = get_tree().get_nodes_in_group("main")[0]
			var world_map = main.go_to_world_map()
			world_map.continue_game = true
			level.level_node.clear_level()
		else:
			get_tree().change_scene_to(next_stage)
