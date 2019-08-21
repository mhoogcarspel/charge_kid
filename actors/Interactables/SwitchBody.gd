extends Block

onready var is_active:bool = false
onready var particles = preload("res://assets/Particles/ProjectileHit.tscn")

export(Array,NodePath) var nodes

func hit(projectile:PhysicsBody2D) -> void:
	$SFX.play()
	$Switch.activate()
	if !is_active:
		add_child(particles.instance())
		is_active = true
		$Timer.start()
	.hit(projectile)

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()



func activate() -> void:
	if not is_active:
		$Switch.activate()
		is_active = true
		$Timer.start()
	else:
		$Switch.deactivate()
		is_active = false
