extends StaticBody2D

onready var active:bool = false

export(Array,NodePath) var nodes
export(Array,NodePath) var wires



func hit(projectile:KinematicBody = null) -> void:
	$SFX.play()
	$AnimationPlayer.play("Activate")
	if not active:
		self.activate()
	
	if projectile != null:
		projectile.change_state("ReturnState")

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()



func activate() -> void:
	if not active:
		var particles = $Sprite.hit_particles.instance()
		particles.position = self.position - Vector2(16,16)
		get_parent().add_child(particles)
		active = true
		for nodepath in wires:
			get_node(nodepath).activate()
		$Timer.start()

func is_active() -> bool:
	return active




