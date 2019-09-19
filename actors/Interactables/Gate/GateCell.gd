tool
extends Node2D

export(bool) var active setget initial_value
onready var delay

func initial_value(new_value: bool) -> void:
	active = new_value
	for child in self.get_children():
		if child is TriggeredPlatform:
			child.trigger(new_value)

func activate() -> void:
	if delay > 0:
		$DelayTimer.start(delay)
		yield($DelayTimer, "timeout")
	for cell in self.get_children():
		if cell is TriggeredPlatform:
			cell.activate()

func deactivate() -> void:
	for cell in self.get_children():
		if cell is TriggeredPlatform:
			cell.deactivate()