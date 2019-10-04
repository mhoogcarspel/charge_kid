extends StaticBody2D

onready var active:bool = false

export(Array,NodePath) var nodes
export(Array,NodePath) var wires



func hit(projectile:PhysicsBody2D) -> void:
	$SFX.play()
	$Switch.activate()
	if not active:
		self.activate()
	projectile.change_state("ReturnState")

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()



func activate() -> void:
	if not active:
		var particles = $Switch/Sprite.particles.instance()
		particles.position -= Vector2(16,16)
		add_child(particles)
		active = true
		for nodepath in wires:
			get_node(nodepath).activate()
		$Timer.start()
	else:
		$Switch.deactivate()
		active = false

func is_active() -> bool:
	return active


