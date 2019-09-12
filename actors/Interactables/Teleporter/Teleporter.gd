extends PhysicsBody2D

func hit(bullet: PhysicsBody2D):
	if !get_tree().get_nodes_in_group("player").empty():
	###############Swap player and bullet positions########################
		var player = get_tree().get_nodes_in_group("player")[0]
		var player_position: Vector2 = player.position
		player.position = bullet.position
		bullet.position = player_position