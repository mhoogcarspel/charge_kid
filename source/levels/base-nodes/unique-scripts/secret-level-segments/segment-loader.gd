extends Area2D

onready var autoscroller = get_parent().get_node("Autoscroller")
onready var loaded = false



func _ready():
	for body in get_overlapping_bodies():
		on_body_entered(body)



func on_body_entered(body):
	if body.is_in_group("player") and not loaded:
		var segment = autoscroller.pick_a_segment().instance()
		segment.position = self.position
		get_parent().add_child(segment)
		loaded = true


