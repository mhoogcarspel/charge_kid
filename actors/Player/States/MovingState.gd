extends PlayerBaseState
class_name MovingState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	return

func update(delta):
	owner.gravity(delta)
	if owner.is_on_floor():
		owner.horizontal_move(get_directional_inputs(), delta)
		var next_state = get_input()
		print(next_state)
		match next_state:
			"NoInput":
				if owner.velocity == Vector2.ZERO:
					owner.change_state("IdleState")
				return
			_:
				owner.change_state(get_input())
	
	else:
		#Go to OnAirState
		return
	
	return
