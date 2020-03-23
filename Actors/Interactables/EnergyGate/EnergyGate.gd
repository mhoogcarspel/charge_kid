tool
extends Node



export (int) var gate_height setget initialize_gate
export (bool) var active setget initial_value
export (String, "Vertical", "Horizontal") var direction setget initial_position
export (PackedScene) var hit_particles

func initial_value(new_value : bool) -> void:
	active = new_value
	for cell in self.get_children():
		if cell.name != "Sparks":
			cell.active = new_value

func initialize_gate(new_value: int) -> void:
	gate_height = new_value
	if Engine.editor_hint:
		get_node("Sparks/BottomEnd").position.y = gate_height*16
		var source_node
		source_node = get_node("EnergyGateCell")
		$Sparks/Hitbox/CollisionShape2D.shape.extents = Vector2(2,gate_height*8 + 8)
		$Sparks/Hitbox/CollisionShape2D.position.y = gate_height*8 - 8
		for child in self.get_children():
			if child.name != "EnergyGateCell" and child.name != "Sparks":
				self.remove_child(child)
		for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)

func initial_position(new_value: String) -> void:
	if Engine.editor_hint:
		match new_value:
			"Vertical":
				self.rotation_degrees = 0
			"Horizontal":
				self.rotation_degrees = -90
	direction = new_value



func add_cells() -> void:
	var source_node = get_node("EnergyGateCell")
	for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)

func activate() -> void:
	self.active = not active
	

func deactivate() -> void:
	self.active = false
	

func is_active() -> bool:
	return active


func _ready():
	add_cells()
	$Sparks/Hitbox/CollisionShape2D.shape.extents = Vector2(2,gate_height*8 + 8)
	$Sparks/Hitbox/CollisionShape2D.position.y = gate_height*8 - 8


func on_hitbox_body_entered(body):
	if not Engine.editor_hint and body.is_in_group("player") and self.is_active():
		if body.get_state() == "BulletBoostingState" or body.get_state() == "BoostingState":
			spawn_particles(body.position)
		else:
			body.change_state("DyingState")

func on_hitbox_area_entered(area):
	if not Engine.editor_hint and area.get_parent().is_in_group("bullet") and self.is_active():
		spawn_particles(area.get_parent().position)

func spawn_particles(spawn_point: Vector2) -> void:
	var level = get_tree().get_nodes_in_group("level")[0]
	var particles = hit_particles.instance()
	particles.position = spawn_point
	level.add_child(particles)




