extends State
class_name PlayerBaseState

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
	print(directionals)
	return directionals

func get_shoot_input() -> bool:
	return Input.is_action_just_pressed("ui_shoot")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("ui_jump")

func get_boost_input() -> bool:
	return Input.is_action_just_pressed("ui_boost")

func is_holding_bullet() -> bool:
	if owner.get_tree().get_nodes_in_group("bullet").size() > 0:
		var bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		if bullet.stack[0] == "HoldState":
			return true
		else:
			return false
	else:
		return false

func get_input() -> String:
	if get_directional_inputs().length() > 0:
		return "MovingState"
	elif get_jump_input():
		return "JumpState"
	elif get_shoot_input() && owner.can_shoot:
		return "ShootingState"
	elif get_boost_input() && owner.can_boost:
		if is_holding_bullet():
			return "BulletBoostingState"
		return "BoostingState"
	
	return "NoInput"

func gravity(delta):
	owner.velocity.y += owner.gravity_acceleration*delta
