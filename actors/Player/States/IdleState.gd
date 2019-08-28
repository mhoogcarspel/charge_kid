extends PlayerBaseState
class_name IdleState

func _init(owner: KinematicBody2D):
	self.owner = owner

func update(delta):
	owner.get_node("AnimationPlayer").play("Idle")
	owner.gravity(delta)
	owner.horizontal_move(get_directional_inputs(), delta)
	if !owner.is_on_floor():
		owner.change_state("OnAirState")
		return
	var next_state = get_input()
	match next_state:
		"NoInput":
			#Do some checks
			return
		_:
			owner.change_state(next_state)
			return
	pass
