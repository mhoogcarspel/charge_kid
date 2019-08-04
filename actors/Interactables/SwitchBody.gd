extends Block

onready var is_active:bool = false
export(Array,NodePath) var nodes

func hit(projectile:PhysicsBody2D) -> void:
	projectile.get_node("ProjectileHit").emitting = true
	if !is_active:
		is_active = true
		$Switch.activate()
		for nodepath in nodes:
			get_node(nodepath).activate()
	else:
		.hit(projectile)