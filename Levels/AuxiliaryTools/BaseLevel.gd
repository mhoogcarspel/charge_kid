extends Node2D
class_name BaseLevel



var level_length: float

func _ready():
	var last_tile = 0
	for tile in $LevelLimits.get_used_cells():
		if tile.x > last_tile:
			last_tile = tile.x
	level_length = last_tile*16


