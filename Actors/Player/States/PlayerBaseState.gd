extends State
class_name PlayerBaseState

onready var animation_player: AnimationPlayer

func enter():
	return

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(owner.control_handler.get_directional_input().x , 0)
	if directionals.x != 0:
		owner.facing = sign(directionals.x)
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



func boosting_particles(switch: bool):
	for particle in owner.get_node("BoostParticles").get_children():
		particle.emitting = switch
	
	if switch == true:
		var shader = owner.shader_effects("Ripple")
		shader.position = owner.position
		shader.speed = 600
		shader.wave_length = 80
		shader.length_increase = 0
		shader.initial_amplitude = 30
		shader.amp_linear_decrease = true
		shader.amp_hyp_decrease = false
		shader.amplitude_decrease = 60
		shader.pulses = 2
		owner.get_parent().add_child(shader)



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




