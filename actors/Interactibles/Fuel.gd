extends StaticBody2D

func hit(bullet: PhysicsBody2D):
	$FuelTank/AnimationPlayer.play("Hit")
	bullet.charge_bullet()
