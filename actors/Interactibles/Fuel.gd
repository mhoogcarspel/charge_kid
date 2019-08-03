extends StaticBody2D

func hit(bullet: PhysicsBody2D):
	bullet.charge_bullet()
	$FuelTank/AnimationPlayer.play("Hit")
	yield($FuelTank/AnimationPlayer,"animation_finished")
	$FuelTank/AnimationPlayer.play("Emptying")
