tool
extends StaticBody2D

export (bool) var active setget trigger
export (String, "Up", "Left", "Down", "Right") var direction setget spin, get_direction



func trigger(new_value: bool) -> void:
	if Engine.editor_hint:
		if new_value == true:
			$Sprite.frame = 0
		else:
			$Sprite.frame = 3
	active = new_value

func spin(new_value: String) -> void:
	match new_value:
		"Up":
			self.rotation_degrees = 0
			direction = new_value
		"Left":
			self.rotation_degrees = -90
			direction = new_value
		"Down":
			self.rotation_degrees = 180
			direction = new_value
		"Right":
			self.rotation_degrees = 90
			direction = new_value

func get_direction() -> Vector2:
	match direction:
		"Up":
			return Vector2.UP
		"Left":
			return Vector2.LEFT
		"Down":
			return Vector2.DOWN
		"Right":
			return Vector2.RIGHT

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



