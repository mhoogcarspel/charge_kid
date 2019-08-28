extends PlayerBaseState
class_name MovingState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	return

func update(delta):
	owner.get_node("AnimationPlayer").play("Walking")
	
	owner.gravity(delta)
	if owner.is_on_floor():
		owner.horizontal_move(get_directional_inputs(), delta)
		var next_state = get_input()
		match next_state:
			"JumpingState":
				owner.change_state("JumpingState")
				return
			"NoInput":
				owner.change_state("IdleState")
				return
			_:
				owner.change_state(get_input())
	
	else:
		owner.change_state("OnAirState")
		return
	
	return
