extends Sprite

onready var player:KinematicBody2D = self.get_parent()
onready var animation_player:AnimationPlayer = player.get_node("AnimationPlayer")

func _process(delta):
	flip_sprite(player.facing)
	if player.is_on_floor() && !player.is_shooting:
		play_move_animation(player.is_moving)
	elif !player.is_shooting:
		animation_player.play("Airborne")
	else:
		animation_player.play("Shooting")
		yield(animation_player, "animation_finished")
		player.is_shooting = false

func flip_sprite(facing: float) -> void:
	if facing > 0 && flip_h:
		flip_h = false
	elif facing < 0 && !flip_h:
		flip_h = true

func play_move_animation(is_moving:bool) -> void:
	if is_moving:
		animation_player.play("Walking")
	else:
		animation_player.play("Idle")

