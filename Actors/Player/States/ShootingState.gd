extends PlayerBaseState
class_name ShootingState



var sfx : AudioStreamPlayer
var left : Area2D
var right : Area2D

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	sfx = owner.get_node("SFX/Shoot")
	left = owner.get_node("LeftAreaChecker")
	right = owner.get_node("RightAreaChecker")



func enter():
	animation_player.play("Shooting")
	sfx.play()
	owner.velocity = Vector2.ZERO
	
	var allow: bool
	if owner.facing < 0:
		allow = check_for_blocks(left)
	else:
		allow = check_for_blocks(right)
	
	if allow:
		var bullet_instance = owner.bullet.instance()
		var bullet_positon = owner.position + Vector2(owner.facing*owner.shoot_offset, 0)
		bullet_instance.direction = Vector2(owner.facing, 0)
		bullet_instance.position = bullet_positon 
		bullet_instance.initial_state = "StandardState"
		owner.get_parent().add_child(bullet_instance)
		if not owner.god_mode:
			owner.has_bullet = false

func check_for_blocks(sensor: Area2D) -> bool:
	var return_value : bool = true
	for body in sensor.get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return_value = false
	return return_value



func update(delta):
	if animation_player.current_animation == "Shooting":
		if owner.is_on_floor():
			if jump_input_pressed():
				return
		
		if boost_input_pressed():
			return
		
		if bullet_boost_input_pressed():
			return
		
	else:
		owner.reset_states_machine()


