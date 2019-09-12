extends PhysicsBody2D

func hit(bullet: PlayerBullet):
	if !get_tree().get_nodes_in_group("player").empty():
	###############Swap player and bullet positions########################
		var player = get_tree().get_nodes_in_group("player")[0]
		var player_position: Vector2 = player.position
		bullet.disable_enable_hitbox(true)
		player.position = bullet.position
		bullet.position = player_position
		yield(get_tree(),"idle_frame")
		bullet.change_state("ReturnState")
		bullet.disable_enable_hitbox(false)