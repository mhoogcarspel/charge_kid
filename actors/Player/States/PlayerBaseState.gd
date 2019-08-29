extends State
class_name PlayerBaseState

onready var animation_player: AnimationPlayer

func enter():
	return

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
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
		if is_holding_bullet():
			owner.change_state("BulletBoostingState")
			return true
		owner.change_state("BoostingState")
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
	if switch:
		owner.get_node("FeetParticles").emitting = false
		owner.get_node("FeetParticles2").emitting = false
		owner.get_node("FeetParticles3").emitting = false
		
	owner.get_node("BoostParticles1").emitting = switch
	owner.get_node("BoostParticles2").emitting = switch
	owner.get_node("BoostParticles3").emitting = switch
	owner.get_node("BoostParticles4").emitting = switch
