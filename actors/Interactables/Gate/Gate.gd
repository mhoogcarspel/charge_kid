tool
extends Node

export (int) var gate_height setget initialize_gate
export (bool) var active setget initial_value
export (float) var delay_between_cells
export (bool) var close_in_inverse_order

func initial_value(new_value : bool) -> void:
	active = new_value
	for cell in self.get_children():
		cell.initial_value(new_value)

func initialize_gate(new_value: int) -> void:
	gate_height = new_value
	if Engine.editor_hint:
		var source_node
		source_node = self.get_node("GateCell")
	
		for gate_cell in self.get_children():
			if gate_cell.name != "GateCell":
				self.remove_child(gate_cell)
		for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)


func add_cells() -> void:
	var source_node = self.get_node("GateCell")
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
	add_cells()
	var i: int = 0
	var j: int
	if close_in_inverse_order:
		j = self.get_children().size()
	else:
		j = 0
	for cell in self.get_children():
		cell.delay = delay_between_cells * abs(j - i)
		i += 1