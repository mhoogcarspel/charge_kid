extends Block

onready var is_active:bool = false

func hit(projectile:PhysicsBody2D) -> void:
	if !is_active:
		is_active = true
		$Switch.activate()
		for node in $Linked.get_children():
			node.activate()
	else:
		.hit(projectile)