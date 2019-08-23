extends Area2D

var main

export(PackedScene) var next_stage



func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().get_nodes_in_group("main").size() > 0:
			main = get_tree().get_nodes_in_group("main")[0]
			main.change_scene(next_stage)
