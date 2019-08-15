extends Node
class_name Block

func hit(bullet: PhysicsBody2D) -> void:
	if !bullet.rigid_state && bullet.standard_state:
		bullet.standard_state = false
		bullet.return_state = true
	else:
		bullet.linear_velocity.x = 0

