extends PlayerBaseState
class_name JumpingState

onready var jumped:bool = false

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func update(delta):
	if !jumped:
		owner.jump()
		jumped = true
	
	if !owner.is_on_floor():
		animation_player.play("Airborne")
		
		#################Checking for any inputs########################
		
		if Input.is_action_just_pressed("ui_shoot") && owner.has_bullet:
			owner.change_state("ShootingState")
			return
		
		elif Input.is_action_just_pressed("ui_boost") && owner.can_boost:
			if is_holding_bullet():
				owner.change_state("BulletBoostingState")
				return
			else:
				owner.change_state("BoostingState")
				return
		##################################################################
		
		owner.horizontal_move(get_directional_inputs(), delta)
		owner.gravity(delta)
	
	else:
		owner.pop_state()

func exit():
	jumped = false