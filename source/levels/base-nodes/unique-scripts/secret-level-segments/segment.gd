extends Node2D


func _ready():
	for child in get_children():
		var level = get_tree().get_nodes_in_group("level")[0]
		var node = child.duplicate()
		node.position = child.position + self.position
		level.call_deferred("add_child", node)
	self.queue_free()
