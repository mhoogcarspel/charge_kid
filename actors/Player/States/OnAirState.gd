extends PlayerBaseState
class_name OnAirState

var coyote_timer:float

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	coyote_timer = 0.0
	return

func update(delta):
	owner.gravity(delta)
	owner.horizontal_move(get_directional_inputs(), delta)
	if !owner.is_on_floor():
		coyote_timer += delta
		match get_input():
			"JumpingState":
				if coyote_timer < owner.coyote_time:
					#Go to JumpState
					return
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
		return
	else:
		owner.pop_state()
		return
