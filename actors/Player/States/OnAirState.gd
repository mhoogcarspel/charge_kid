extends PlayerBaseState
class_name OnAirState

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

onready var coyote_time:float = 0

func enter():
	coyote_time = 0

func update(delta):
	coyote_time += delta
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	if !owner.is_on_floor():
		animation_player.play("Airborne")
		
		#################Checking for any inputs########################
		
		if Input.is_action_just_pressed("ui_jump") && coyote_time < owner.coyote_time:
			owner.change_state("JumpingState")
			return
		
		if shoot_input_pressed():
			return
		
		elif boost_input_pressed():
			return
		
		elif bullet_boost_input_pressed():
			return
		##################################################################
	
	else:
		land_sound()
		owner.pop_state()
	pass
