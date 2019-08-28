extends PlayerBaseState
class_name IdleState

func update(delta):
	if !owner.is_on_floor():
		#Go to OnAirState
		return
	 
	match get_input():
		"MovingState":
			#Go to Moving State
			return
		"JumpState":
			#Go to Jump State
			return
		"ShootingState":
			#Go to Shooting State
			return
		"BoostingState":
			#Go to Boosting State
			return
		"BulletBoostingState":
			#Go to Boosting
			return
		"NoInput":
			#Do some checks
			return
	pass
