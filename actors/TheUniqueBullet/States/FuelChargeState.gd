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
	owner.get_node("FuelChargeParticles").emitting = true
	owner.get_node("FuelChargeParticles/CPUParticles2D").emitting = true
	owner.get_node("ProjectileParticles").emitting = false
	owner.set_collision_mask_bit(0, false)
	owner.set_collision_layer_bit(0, false)

func exit():
	owner.get_node("FuelChargeParticles").emitting = false
	owner.get_node("FuelChargeParticles/CPUParticles2D").emitting = false
	owner.get_node("ProjectileParticles").emitting = true
	owner.set_collision_mask_bit(0, true)
	owner.set_collision_layer_bit(0, true)

func update(delta):
	var direction = (player.position - owner.position).normalized()
	move_bullet(direction, velocity)