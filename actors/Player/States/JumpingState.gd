extends PlayerBaseState
class_name JumpingState

onready var jumped:bool = false
onready var factor: float = 1

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.jump()

func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.gravity(delta)
	if !owner.is_on_floor():
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
		
		if Input.is_action_just_pressed("ui_jump"):
			owner.get_node("BunnyTimer").start(owner.bunny_time)
		return
	
	else:
		land_sound()
		if !owner.get_node("BunnyTimer").is_stopped():
			owner.get_node("BunnyTimer").stop()
			owner.change_state("JumpingState")
		else:
			owner.pop_state()
		return



