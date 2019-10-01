tool
extends Node



export (int) var gate_height setget initialize_gate
export (bool) var active setget initial_value
export (String, "Vertical", "Horizontal") var direction setget initial_position

func initial_value(new_value : bool) -> void:
	active = new_value
	for cell in self.get_children():
		cell.set_active(new_value)
	if not Engine.editor_hint:
		$Sparks1.emitting = active
		$Sparks2.emitting = active

func initialize_gate(new_value: int) -> void:
	gate_height = new_value
	if Engine.editor_hint:
		var source_node
		source_node = self.get_node("EnergyGateCell")
	
		for child in self.get_children():
			if child.name != "EnergyGateCell" and child.name != "Sparks1" and child.name != "Sparks2":
				self.remove_child(child)
		for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)
		
		$Sparks2.position.y = gate_height*16 - 8

func initial_position(new_value: String) -> void:
	match new_value:
		"Vertical":
			self.rotation_degrees = 0
		"Horizontal":
			self.rotation_degrees = -90
	direction = new_value



func add_cells() -> void:
	var source_node = self.get_node("EnergyGateCell")
	for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)

func activate() -> void:
	if !active:
		active = true
	for cell in self.get_children():
		cell.activate()

func deactivate() -> void:
	if active:
		active = false
	for cell in self.get_children():
		cell.deactivate()

func is_active() -> bool:
	return active



func _ready():
	if not Engine.editor_hint:
		add_cells()
		$Sparks1.emitting = active
		$Sparks2.emitting = active




