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
	owner.get_node("FeetParticles").emitting = false
	owner.get_node("FeetParticles2").emitting = false
	owner.get_node("FeetParticles3").emitting = false
	owner.get_node("BoostParticles1").emitting = true
	owner.get_node("BoostParticles2").emitting = true
	owner.get_node("BoostParticles3").emitting = true
	owner.get_node("BoostParticles4").emitting = true

func update(delta):
	boosting_time += delta
	
	#######################Finishing the boost timer ###########################
	if boosting_time > owner.boost_time:
		owner.get_node("BoostParticles1").emitting = false
		owner.get_node("BoostParticles2").emitting = false
		owner.get_node("BoostParticles3").emitting = false
		owner.get_node("BoostParticles4").emitting = false
		owner.horizontal_move(get_directional_inputs(), delta, 3)
		owner.gravity(delta, 2)
	
		if Input.is_action_just_pressed("ui_boost") && owner.can_boost:
			if is_holding_bullet():
				owner.change_state("BulletBoostingState")
				return
			else:
				owner.change_state("BoostingState")
				return
	###############################################################################
	
	if !owner.is_on_floor():
		animation_player.play("Airborne")
	
		#################Checking for any inputs########################
		if Input.is_action_just_pressed("ui_shoot") && owner.has_bullet:
			owner.change_state("ShootingState")
			return
		##################################################################
	
	else:
		owner.pop_state()
		return