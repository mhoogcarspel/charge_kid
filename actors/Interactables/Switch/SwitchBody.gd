extends Block

onready var is_active:bool = false

export(Array,NodePath) var nodes
export(Array,NodePath) var wires



func _ready():
	for nodepath in wires:
		print(nodepath)


func hit(projectile:PhysicsBody2D) -> void:
	$SFX.play()
	self.activate()
	.hit(projectile)

func _on_Timer_timeout():
	for nodepath in nodes:
		get_node(nodepath).activate()



func activate() -> void:
	if not is_active:
		$Switch.activate()
		is_active = true
		for nodepath in wires:
			get_node(nodepath).activate()
		$Timer.start()
	else:
		$Switch.deactivate()
		is_active = false



