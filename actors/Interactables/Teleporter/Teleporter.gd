extends PhysicsBody2D

onready var actual_state: String = "Active"

func _process(delta):
	if actual_state == "Active":
		$AnimationPlayer.play("Standard")
	elif actual_state == "Deactivated":
		$AnimationPlayer.play("Deactivated")

func hit(bullet: PlayerBullet):
	if !get_tree().get_nodes_in_group("player").empty():
	###############Swap player and bullet positions########################
		swap_player_and_bullet(bullet)
		
		$AnimationPlayer.play("Closing")
		yield($AnimationPlayer, "animation_finished")
		$ReactivationTimer.start()
		actual_state = "Deactivated"

func _on_ReactivationTimer_timeout():
	actual_state == "Reactivating"
	$AnimationPlayer.play("Activating")
	yield($AnimationPlayer, "animation_finished")
	self.set_collision_layer_bit(5, true)
	actual_state = "Active"

func swap_player_and_bullet(bullet: PlayerBullet):
	var player = get_tree().get_nodes_in_group("player")[0]
	var player_position: Vector2 = player.position
	bullet.disable_enable_hitbox(false)
	player.position = bullet.position
	bullet.position = player_position
	yield(get_tree(),"idle_frame")
	
	bullet.change_state("ReturnState")
	bullet.disable_enable_hitbox(true)
	self.set_collision_layer_bit(5, false)
	actual_state = ""