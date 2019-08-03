extends Area2D

export(float) var bullet_velocity

onready var direction: Vector2

func _physics_process(delta):
	move(direction, delta)

func move(direction: Vector2, delta:float):
	self.position += bullet_velocity*direction*delta
	pass