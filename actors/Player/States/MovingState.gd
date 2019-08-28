extends PlayerBaseState
class_name MovingState

func enter():
	return

func update(delta):
	if owner.is_on_floor:
		match get_input():
			"JumpingState":
				#Go to JumpingState
				return
			"ShootingState":
				#Go to ShootingState
				return
			"BoostingState":
				#Go to BoostingState
				return
			"BulletBoostingState":
				#Go to BulletBoostingState
				return
			"NoInput":
				#Go to IdleState
				return
		owner.move(get_directional_inputs(), delta)
	
	else:
		#Go to OnAirState
		return
	
	return
