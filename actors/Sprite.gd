extends Sprite

onready var player:KinematicBody2D = self.get_parent()
onready var animation_player:AnimationPlayer = player.get_node("AnimationPlayer")

func _process(delta):
	flip_sprite(player.facing)
	play_move_animation(player.is_moving)
	pass

func flip_sprite(facing) -> void:
	if facing > 0 && flip_h:
		flip_h = false
	elif facing < 0 && !flip_h:
		flip_h = true

func play_move_animation(is_moving) -> void:
	if is_moving:
		animation_player.play("Walking")
	else:
		animation_player.play("Idle")
