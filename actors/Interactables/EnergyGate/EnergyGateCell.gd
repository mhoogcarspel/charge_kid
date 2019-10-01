tool
extends Node2D



var ready = false

export (bool) var active setget set_active
export (PackedScene) var hit_particles
export (PackedScene) var gate_particles

func set_active(new_value):
	if Engine.editor_hint or ready:
		if new_value == true:
			get_node("Sprite").visible = true
			get_node("Hitbox/CollisionShape2D").disabled = false
		else:
			get_node("Sprite").visible = false
			get_node("Hitbox/CollisionShape2D").disabled = true
	active = new_value



func on_body_entered(body):
	if not Engine.editor_hint and body.is_in_group("player"):
		if body.get_state() == "BulletBoostingState" or body.get_state() == "BoostingState":
			spawn_particles(body.position)
		else:
			body.change_state("DyingState")

func on_area_entered(area):
	if not Engine.editor_hint and area.get_parent().is_in_group("bullet"):
		spawn_particles(area.get_parent().position)

func spawn_particles(spawn_point: Vector2) -> void:
	var level = get_tree().get_nodes_in_group("level")[0]
	var particles = hit_particles.instance()
	particles.position = spawn_point
	level.add_child(particles)



func activate():
	self.active = true

func deactivate():
	self.active = false

func is_active():
	return active



func _ready():
	if not Engine.editor_hint:
		ready = true
		set_active(get_parent().is_active())
		$Sprite.frame = randi()%3
		$Sprite/Timer.start()
		self.add_child(gate_particles.instance())



