extends State
class_name PlayerBaseState

onready var animation_player: AnimationPlayer

func enter():
	return

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(owner.control_handler.get_directional_input().x , 0)
	if directionals.x != 0:
		owner.facing = directionals.x/abs(directionals.x)
	return directionals

func shoot_input_pressed() -> bool:
	if Input.is_action_just_pressed("ui_shoot") && owner.has_bullet:
		owner.change_state("ShootingState")
		return true
	return false

func jump_input_pressed() -> bool:
	if Input.is_action_just_pressed("ui_jump"):
		owner.change_state("JumpingState")
		return true
	return false

func boost_input_pressed() -> bool:
	if Input.is_action_just_pressed("ui_boost") && owner.can_boost:
		owner.change_state("BoostingState")
		return true
	return false

func bullet_boost_input_pressed() -> bool:
	if Input.is_action_just_pressed("ui_bullet_boost") && is_holding_bullet() && owner.can_boost:
		owner.change_state("BulletBoostingState")
		return true
	return false

func is_holding_bullet() -> bool:
	if owner.get_tree().get_nodes_in_group("bullet").size() > 0:
		var bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		if bullet.stack[0] == "HoldState":
			return true
		else:
			return false
	else:
		return false

func gravity(delta):
	owner.velocity.y += owner.gravity_acceleration*delta

func boosting_particles(switch: bool):
	for particle in owner.get_node("BoostParticles").get_children():
		particle.emitting = switch
	

func store_checkpoint() -> void:
	var left: bool = false
	var right: bool = false
	for body in owner.get_node("LeftLedgeDetector").get_overlapping_bodies():
		if body.is_in_group("blocks") or body.is_in_group("platform"):
			left = true
	for body in owner.get_node("RightLedgeDetector").get_overlapping_bodies():
		if body.is_in_group("blocks") or body.is_in_group("platform"):
			right = true
	
	if left and right and owner.get_node("SpikesSentinel").get_overlapping_areas().empty():
		owner.checkpoint = owner.position

func land_sound() -> void:
	owner.get_node("AnimationPlayer").play("Landing")
	owner.get_node("SFX/Land").play()
	return



