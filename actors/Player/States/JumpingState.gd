extends PlayerBaseState
class_name JumpingState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	owner.velocity.y = -owner.jump_velocity
	return


func update(delta):
	owner.get_node("AnimationPlayer").play("Airborne")
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	if !owner.is_on_floor():
		var state = get_input()
		match get_input():
			"ShootingState", "BoostingState", "BulletBoosting":
				owner.change_state(state)
				return
			_:
				return
			
		
		if Input.is_action_just_released("ui_jump") && owner.velocity.y <= 0:
			print("N~ao ta indo")
			owner.velocity.y = 0
		return
		
	else:
		owner.pop_state()
		return
