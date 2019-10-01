tool
extends StaticBody2D


var active: bool = true setget set_active
var height: int = 1 setget set_height
onready var gate = get_parent().get_parent()

func set_active(new_value) -> void:
	match new_value:
		true:
			$Sprite.frame = 0
		false:
			$Sprite.frame = 2
	active = new_value

func set_height(new_value: int) -> void:
	if new_value > 0:
		self.position.y = new_value*16
	else:
		self.position.y = 16
	height = new_value



func _process(delta):
	if not Engine.editor_hint:
		if gate.is_active():
			$AnimationPlayer.play("On")
		else:
			$AnimationPlayer.play("Off")



