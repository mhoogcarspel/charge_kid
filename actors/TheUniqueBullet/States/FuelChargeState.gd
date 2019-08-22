extends BulletBaseState
class_name FuelChargeState

onready var player: KinematicBody2D = get_tree().get_nodes_in_group("player")[0]

func enter():
	var velocity: float = owner.velocity
	var direction: Vector2 = (player.position - owner.position).normalized()
	owner.get_node("PhysicalCollider").disabled = true

func update():
	var direction = (player.position - owner.position).normalized()
	move_bullet(direction, velocity)