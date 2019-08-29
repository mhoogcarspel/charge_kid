extends PlayerBaseState
class_name IdleState

onready var coyote_timer: float = 0

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	coyote_timer = 0

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	owner.drop()
	if owner.is_on_floor():
		coyote_timer = 0.0
		animation_player.play("Idle")
		store_checkpoint()
		
		#################Checking for any inputs########################
		if jump_input_pressed():
			return
		
		elif shoot_input_pressed():
			return
		
		elif boost_input_pressed():
			return
		
		elif get_directional_inputs().length() > 0:
			owner.change_state("MovingState")
			return
		
		return
		##################################################################
	
	else:
		owner.change_state("OnAirState")
		return
