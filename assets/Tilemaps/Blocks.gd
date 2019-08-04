extends Node
class_name Block

func hit(bullet: PhysicsBody2D) -> void:
	bullet.get_node("ProjectileHit").emitting = true
	
	if !bullet.rigid_state && bullet.standard_state:
		bullet.standard_state = false
		bullet.return_state = true
	pass
