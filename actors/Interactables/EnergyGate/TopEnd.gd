tool
extends StaticBody2D


var active: bool = true setget set_active
onready var gate = get_parent().get_parent()

func set_active(new_value) -> void:
	match new_value:
		true:
			$Sprite.frame = 0
		false:
			$Sprite.frame = 2
	active = new_value


func _process(delta):
	if not Engine.editor_hint:
		if gate.is_active():
			$AnimationPlayer.play("On")
		else:
			$AnimationPlayer.play("Off")



