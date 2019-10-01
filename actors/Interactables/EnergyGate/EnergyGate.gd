tool
extends Node



export (int) var gate_height setget initialize_gate
export (bool) var active setget initial_value
export (String, "Vertical", "Horizontal") var direction setget initial_position

func initial_value(new_value : bool) -> void:
	active = new_value
	for cell in self.get_children():
		if cell.name != "Sparks":
			cell.active = new_value

func initialize_gate(new_value: int) -> void:
	gate_height = new_value
	if Engine.editor_hint:
		get_node("Sparks/BottomEnd").height = gate_height
		var source_node
		source_node = get_node("EnergyGateCell")
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
	self.active = true

func deactivate() -> void:
	self.active = false

func is_active() -> bool:
	return active



func _ready():
	add_cells()




