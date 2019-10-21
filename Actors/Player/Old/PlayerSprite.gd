extends Sprite

onready var player:KinematicBody2D = self.get_parent()
onready var animation_player:AnimationPlayer = player.get_node("AnimationPlayer")
onready var step: int = 0
onready var is_player_airborne: bool = false setget falling_sentinel

func _process(delta):
	$ProjectileParticles.emitting = player.can_shoot
	flip_sprite(player.facing)
	
	if player.is_on_floor() && !player.is_shooting && !player.is_boosting:
		play_move_animation(player.is_moving)
	elif player.is_boosting:
		animation_player.play("Airborne")
	elif !player.is_shooting:
		animation_player.play("Airborne")
	else:
		animation_player.play("Shooting")
		yield(animation_player, "animation_finished")
		player.is_shooting = false
	
	self.is_player_airborne = player.is_airborne()


func step_sound() -> void:
	if step == 0:
		player.get_node("SFX/Step").pitch_scale = 0.8
		player.get_node("SFX/Step").play()
		step = 1
	elif step == 1:
		player.get_node("SFX/Step").pitch_scale = 0.9
		player.get_node("SFX/Step").play()
		step = 0


func falling_sentinel(new_value) -> void:
	if new_value == false and is_player_airborne == true:
		player.get_node("SFX/Land").play()
	elif new_value == true and is_player_airborne == false:
		player.checkpoint = player.pre_checkpoint
	is_player_airborne = new_value


func flip_sprite(facing: float) -> void:
	if facing > 0 && !self.transform.x.x == 1:
		self.transform.x.x = 1
	elif facing < 0 && !self.transform.x.x == -1:
		self.transform.x.x = -1



func play_move_animation(is_moving:bool) -> void:
	if is_moving:
		animation_player.play("Walking")
	else:
		animation_player.play("Idle")

