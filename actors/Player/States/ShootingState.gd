extends PlayerBaseState
class_name ShootingState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	owner.shoot()
	owner.yield(owner.get_node("PlayerSprite"), "animation_finished")
	owner.pop_state()
