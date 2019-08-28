extends PlayerBaseState
class_name OnAirState

func update(delta):
	if !owner.is_on_floor:
		match get_input():
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
		return
	else:
		owner.pop_state()
		return
