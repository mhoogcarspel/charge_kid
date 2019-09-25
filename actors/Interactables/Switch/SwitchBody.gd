extends StaticBody2D

onready var is_active:bool = false

export(Array,NodePath) var nodes
export(Array,NodePath) var wires



func hit(projectile:PhysicsBody2D) -> void:
	$SFX.play()
	$Switch.activate()
	if not is_active:
		self.activate()
	projectile.change_state("ReturnState")

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()



func activate() -> void:
	if not is_active:
		var particles = $Switch/Sprite.particles.instance()
		particles.position -= Vector2(16,16)
		add_child(particles)
		is_active = true
		for nodepath in wires:
			get_node(nodepath).activate()
		$Timer.start()
	else:
		$Switch.deactivate()
		is_active = false



