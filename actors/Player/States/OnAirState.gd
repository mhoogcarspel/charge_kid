extends PlayerBaseState
class_name OnAirState

var coyote
var bunny

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	self.bunny = owner.get_node("BunnyTimer")
	self.coyote = owner.get_node("CoyoteTimer")

func enter():
	coyote.start(owner.coyote_time)

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	if !owner.is_on_floor():
		animation_player.play("Airborne")
		
		#################Checking for any inputs########################
		if Input.is_action_just_pressed("ui_jump"):
			if !coyote.is_stopped():
				owner.change_state("JumpingState")
				coyote.stop()
				return
			elif coyote.is_stopped():
				bunny.start()
		
		
		if shoot_input_pressed():
			return
		
		elif boost_input_pressed():
			return
		
		elif bullet_boost_input_pressed():
			return
		##################################################################
	
	else:
		land_sound()
		if not bunny.is_stopped() and Input.is_action_pressed("ui_jump"):
			bunny.stop()
			print("BunnyHooooop")
			owner.change_state("JumpingState")
		
		else:
			owner.pop_state()
	pass
