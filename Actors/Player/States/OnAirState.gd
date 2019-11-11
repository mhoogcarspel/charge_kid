extends PlayerBaseState
class_name OnAirState

var coyote
var bunny
var post_bullet_boost

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	self.bunny = owner.get_node("BunnyTimer")
	self.coyote = owner.get_node("CoyoteTimer")

func enter():
	post_bullet_boost = abs(owner.velocity.x)/owner.air_friction

func update(delta):
	owner.vertical_move(delta)
	
	if owner.stack[1] == "BulletBoostingState" and post_bullet_boost > 0:
		owner.horizontal_move(get_directional_inputs(), delta, 1.0, true)
		post_bullet_boost -= delta
	else:
		owner.horizontal_move(get_directional_inputs(), delta)
	
	if not owner.is_on_floor():
		animation_player.play("Airborne")
		
		################# Checking for any inputs ########################
		if Input.is_action_just_pressed("ui_jump"):
			if not coyote.is_stopped():
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
		if not bunny.is_stopped() and Input.is_action_pressed("ui_jump"):
			bunny.stop()
			owner.change_state("JumpingState")
		else:
			owner.pop_state()




