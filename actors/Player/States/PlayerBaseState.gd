extends State
class_name PlayerBaseState

onready var animation_player

func enter():
	return

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
	if directionals.x != 0:
		owner.facing = directionals.x/abs(directionals.x)
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

func gravity(delta):
	owner.velocity.y += owner.gravity_acceleration*delta
