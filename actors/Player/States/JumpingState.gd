extends PlayerBaseState
class_name JumpingState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	owner.velocity.y = -owner.jump_velocity

func update(delta):
	if !owner.is_on_floor:
		match get_input():
			"ShootingState":
				#Go to ShootingState
				return
			"BoostingState":
				#Go to BoostingState
				return
			"BulletBoostingState":
				#Go to BulletBoostingState
				return
			
		owner.move(get_directional_inputs(), delta)
		
		if !Input.is_action_pressed("ui_jump") && owner.velocity.y < 0:
			owner.velocity.y = 0
		return
		
	else:
		owner.pop_state()
		return
