extends PlayerBaseState
class_name ShootingState

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.shoot()
	yield(animation_player, "animation_finished")
	owner.pop_state()
