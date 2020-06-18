extends Area2D

onready var autoscroller = get_parent().get_node("Autoscroller")
onready var loaded = false

var segment



func _on_Timer_timeout():
	segment = autoscroller.pick_a_segment()
	self.monitoring = true



func on_body_entered(body):
	if body.is_in_group("player") and not loaded:
		segment = segment.instance()
		segment.position = self.position
		get_parent().call_deferred("add_child", segment)
		loaded = true


