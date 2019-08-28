extends PlayerBaseState
class_name MovingState

onready var coyote_timer: float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	coyote_timer = 0

func update(delta):
	if owner.is_on_floor():
		coyote_timer = 0.0
		animation_player.play("Walking")
		
		#################Checking for any inputs########################
		if Input.is_action_just_pressed("ui_jump"):
			owner.change_state("JumpingState")
			return
		
		elif Input.is_action_just_pressed("ui_shoot") && owner.has_bullet:
			owner.change_state("ShootingState")
			return
		
		elif Input.is_action_just_pressed("ui_boost") && owner.can_boost:
			if is_holding_bullet():
				owner.change_state("BulletBoostingState")
				return
			else:
				owner.change_state("BoostingState")
				return
		
		elif get_directional_inputs().length() == 0 && owner.velocity.length() == 0:
			owner.change_state("IdleState")
			return
		##################################################################
		
		owner.horizontal_move(get_directional_inputs(), delta)
		owner.gravity(delta)
	
	else:
		coyote_timer += delta
		if coyote_timer > owner.coyote_time:
			owner.change_state("OnAirState")
