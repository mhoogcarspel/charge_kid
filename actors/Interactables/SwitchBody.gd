extends Block

onready var is_active:bool = false
onready var particles = preload("res://assets/Particles/ProjectileHit.tscn")

export(Array,NodePath) var nodes

func hit(projectile:PhysicsBody2D) -> void:
	add_child(particles.instance())
	if !is_active:
		$SFX.play()
		is_active = true
		$Switch.activate()
		$Timer.start()
	else:
		.hit(projectile)

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()
