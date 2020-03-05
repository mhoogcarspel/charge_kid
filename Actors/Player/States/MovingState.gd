extends PlayerBaseState
class_name MovingState



func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	if animation_player.current_animation != "Landing":
		owner.get_node("PlayerSprite").step_sound()

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.vertical_move(delta)
	owner.drop()
	if owner.is_on_floor():
		if animation_player.current_animation != "Landing":
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
			owner.reset_states_machine()
		##################################################################
	
	else:
		owner.change_state("OnAirState")


