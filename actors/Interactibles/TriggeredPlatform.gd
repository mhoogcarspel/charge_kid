tool
extends StaticBody2D

export (bool) var active setget trigger



func trigger(new_value: bool) -> void:
	if Engine.editor_hint:
		if new_value == true:
			$Sprite.frame = 0
		else:
			$Sprite.frame = 3
	active = new_value

func _ready():
	if !Engine.editor_hint:
		if active:
			$Sprite.frame = 0
			$Hitbox.disabled = false
		else:
			$Sprite.frame = 3
			$Hitbox.disabled = true



func activate() -> void:
	if not is_active():
		$AnimationPlayer.play("Activate")
		active = true

func deactivate() -> void:
	if is_active():
		$AnimationPlayer.play("Deactivate")
		active = false

func is_active() -> bool:
	return active



