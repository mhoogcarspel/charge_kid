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
	if owner.get_previous_state() == "BoostingState" and owner.velocity.y < 0:
		owner.vertical_move(delta, 3)
	elif owner.get_previous_state() == "BulletBoostingState" and owner.velocity.y < 0:
		owner.vertical_move(delta, 3)
	else:
		owner.vertical_move(delta)
	
	if owner.get_previous_state() == "BulletBoostingState" and post_bullet_boost > 0:
		owner.horizontal_move(get_directional_inputs(), delta, 1.0, true)
		post_bullet_boost -= delta
	else:
		owner.horizontal_move(get_directional_inputs(), delta)
	
	if not owner.is_on_floor():
		animation_player.play("Airborne")
		
		################# Checking for any inputs ########################
		if jump_input_pressed():
			return
		elif shoot_input_pressed():
			return
		elif boost_input_pressed():
			return
		elif bullet_boost_input_pressed():
			return
		##################################################################
		
	elif owner.is_on_floor() and owner.velocity.y > 0:
		animation_player.play("Landing")
		owner.reset_states_machine()
	





