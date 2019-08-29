extends PlayerBaseState
class_name DyingState

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.velocity = Vector2.ZERO
	owner.kill()
