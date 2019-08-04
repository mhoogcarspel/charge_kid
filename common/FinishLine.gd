extends Area2D

onready var main = get_tree().get_nodes_in_group("main")[0]

export(PackedScene) var next_stage

func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		main.change_scene(next_stage)
