extends PlayerBaseState
class_name ShootingState



var sfx : AudioStreamPlayer

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
#	sfx = owner.get_node("SFX/Shoot")
	owner.get_node("SFX/Shoot").pitch_scale = rand_range(0.9, 1.6)
	owner.get_node("SFX/Shoot").set_stream(owner.get_node("PlayerSprite").shoot_sounds[randi()%3])
	owner.get_node("SFX/Shoot").get_stream().set_loop(false)
	



func enter():
	animation_player.play("Shooting")
#	sfx.play()
	owner.get_node("SFX/Shoot").play()
	
	## If gravity is not aplied when the owner is on floor 
	## the is_on_floor() function will return false 
	## and after that the OnAirState will be triggered
	if !owner.is_on_floor():
		owner.velocity.y = 0.0
	owner.velocity.x = 0.0
	################----------------####################
	
	var bullet_instance = owner.bullet.instance()
	var bullet_positon = owner.position
	bullet_instance.direction = Vector2(owner.facing, 0)
	bullet_instance.position = bullet_positon 
	bullet_instance.initial_state = "StandardState"
	owner.get_parent().add_child(bullet_instance)
	if not owner.god_mode:
		owner.has_bullet = false



func update(delta):
	if animation_player.current_animation == "Shooting":
		if owner.is_on_floor():
			owner.vertical_move(delta)
			if jump_input_pressed():
				return
		
		if boost_input_pressed():
			return
		
		if bullet_boost_input_pressed():
			return
		
	else:
		owner.reset_states_machine()


