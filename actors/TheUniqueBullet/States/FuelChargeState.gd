extends BulletBaseState
class_name FuelChargeState

onready var player: KinematicBody2D
onready var velocity: float
onready var direction: Vector2

func _init(owner: Node, player):
	self.owner = owner
	self.player = player

func enter():
	velocity = owner.velocity_fuel
	direction = (player.position - owner.position).normalized()
	owner.get_node("PhysicalCollider").disabled = true

func update(delta):
	var direction = (player.position - owner.position).normalized()
	move_bullet(direction, velocity)