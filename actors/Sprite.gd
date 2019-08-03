extends Sprite

onready var player:KinematicBody2D = self.get_parent()

func _process(delta):
	flip_sprite(player.facing)
	pass

func flip_sprite(facing) -> void:
	if facing > 0 && flip_h:
		flip_h = false
	elif facing < 0 && !flip_h:
		flip_h = true

func play_move_animation(is_moving) -> void:
	if is_moving:
		$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.play("Idle")
