extends PlayerBaseState
class_name MovingState

onready var coyote_timer: float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	coyote_timer = 0

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta, 2)
	owner.gravity(delta)
	owner.drop()
	if owner.is_on_floor():
		animation_player.play("Walking")
		store_checkpoint()
		
		#################Checking for any inputs########################
		if jump_input_pressed():
			return
		
		elif shoot_input_pressed():
			return
		
		elif boost_input_pressed():
			return
		
		elif bullet_boost_input_pressed():
			return
		
		elif get_directional_inputs().length() == 0 && owner.velocity.x == 0:
			print("NoMovement")
			owner.pop_state()
		##################################################################
	
	else:
		owner.change_state("OnAirState")

