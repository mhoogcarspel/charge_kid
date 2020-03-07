extends StaticBody2D

onready var active: bool = false
onready var just_activated: bool = false

export(Array,NodePath) var nodes
export(Array,NodePath) var wires



func hit(projectile: KinematicBody2D) -> void:
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
		just_activated = true

func deactivate() -> void:
	active = false
	$Sprite.light_down()
	for nodepath in nodes:
		get_node(nodepath).deactivate()
	for nodepath in wires:
		get_node(nodepath).deactivate()

func is_active() -> bool:
	return active



func _physics_process(_delta):
	if just_activated and not get_tree().get_nodes_in_group("player").empty():
		var player = get_tree().get_nodes_in_group("player")[0]
		if player.get_state() == "DyingState":
			self.deactivate()
		elif player.is_on_floor():
			just_activated = false




