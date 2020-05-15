extends PlayerBaseState
class_name BoostingState

onready var boosting_time:float = 0.0

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.can_boost = false
	boosting_time = 0.0
	owner.velocity = Vector2(0, -owner.boost_speed)
	owner.get_node("SFX/Boost").pitch_scale = rand_range(1.0, 1.3)
	owner.get_node("SFX/Boost").set_stream(owner.get_node("PlayerSprite").boost_sounds[randi()%3])
	owner.get_node("SFX/Boost").get_stream().set_loop(false)
	owner.get_node("SFX/Boost").play()
	owner.set_collision_mask_bit(1, false)
	boosting_particles(true)

func update(delta):
	boosting_time += delta
	animation_player.play("Airborne")
	
	if shoot_input_pressed():
		return
	if boost_input_pressed():
		return
	if bullet_boost_input_pressed():
		return
	
	if boosting_time < owner.boost_time:
		owner.horizontal_move(get_directional_inputs(), delta, 0.5)
	else:
		owner.change_state("OnAirState")

func exit():
	owner.set_collision_mask_bit(1, true)
	boosting_particles(false)



