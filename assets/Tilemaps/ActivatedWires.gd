extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func activate() -> void:
	self.visible = true

func deactivate() -> void:
	self.visible = false