extends PlayerBaseState
class_name JumpingState

onready var jumped: bool = false
onready var factor: float = 1

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.jump()

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	animation_player.play("Airborne")
	
	################# Checking for any inputs ########################
	if shoot_input_pressed():
		return
	
	elif boost_input_pressed():
		return
	
	elif bullet_boost_input_pressed():
		return
	##################################################################
	
	if Input.is_action_just_released("ui_jump") && owner.velocity.y < 0:
		owner.velocity.y /= 3
		owner.pop_state()
	
	if owner.velocity.y >= 0:
		owner.pop_state()



