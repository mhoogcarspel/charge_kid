extends Node2D
class_name BaseLevel

export(bool) var bgm_1
export(bool) var bgm_2
export(bool) var bgm_3
export(bool) var bgm_4

onready var sound_control:SoundControl = get_tree().get_nodes_in_group("sound_control")[0]

var level_node
var level_length: float

func _ready():
	var last_tile = 0
	for tile in $LevelLimits.get_used_cells():
		if tile.x > last_tile:
			last_tile = tile.x
	level_length = last_tile*16
	sound_control.zero_all_bgm()
	sound_control.set_volume_bgm([bgm_1, bgm_2, bgm_3, bgm_4])
	


