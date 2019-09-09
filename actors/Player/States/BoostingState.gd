extends PlayerBaseState
class_name BoostingState

onready var boosting_time:float = 0.0

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.can_boost = false
	boosting_time = 0.0
	owner.velocity = Vector2(0, -owner.boost_speed)
	owner.get_node("SFX/SuperJump").play()
	boosting_particles(true)

func update(delta):
	boosting_time += delta
	owner.horizontal_move(get_directional_inputs(), delta, 0.5)
	#######################Finishing the boost timer ###########################
	if boosting_time > owner.boost_time*3/4:
		if boost_input_pressed():
			return
	###############################################################################
	
	if boosting_time > owner.boost_time:
		owner.gravity(delta, 2)
		boosting_particles(false)
	
	if !owner.is_on_floor():
		animation_player.play("Airborne")
	
		#################Checking for any inputs########################
		if shoot_input_pressed():
			return
		##################################################################
	
	else:
		land_sound()
		owner.pop_state()
		return

func exit():
	boosting_particles(false)