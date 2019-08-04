extends StaticBody2D

export(Array,NodePath) var nodes

onready var is_active:bool = false

func _ready():
	if is_active:
		$Lever.frame = 4
	else:
		$Lever.frame = 0

func hit(bullet:PhysicsBody2D):
	bullet.get_node("ProjectileHit").emitting = true
	if is_active:
		$Lever/AnimationPlayer.play("Deactivate")
		is_active = false
	else:
		$Lever/AnimationPlayer.play("Activate")
		is_active = true
	for nodepath in  nodes:
		toggle(get_node(nodepath))
	if !bullet.rigid_state && bullet.standard_state:
		bullet.standard_state = false
		bullet.return_state = true
	
	print(is_active)

func toggle(object:Node) -> void:
	if object.is_active:
		object.deactivate()
	else:
		object.activate()