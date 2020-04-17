extends Node2D
class_name BaseLevel



export (int) var level

export (bool) var bgm_1
export (bool) var bgm_2
export (bool) var bgm_3
export (bool) var bgm_4

export (PackedScene) var player_scene

onready var message = $MessageLabel
onready var message_timer = get_node("MessageLabel/Timer")

var level_length: float



func _ready():
	var last_tile = 0
	for tile in $LevelLimits.get_used_cells():
		if tile.x > last_tile:
			last_tile = tile.x
	level_length = last_tile*16
	
	if get_tree().get_nodes_in_group("sound_control").size() > 0:
		var sound_control = get_tree().get_nodes_in_group("sound_control")[0]
		sound_control.set_volume_bgm([bgm_1, bgm_2, bgm_3, bgm_4])
	
	if get_tree().get_nodes_in_group("main").size() > 0:
		var file_save = get_tree().get_nodes_in_group("main")[0].get_node("SaveFileHandler")
		file_save.progress["levels"] = max(level, file_save.progress["levels"])
		file_save.save_progress()

func _process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	if player != null:
		var pos: Vector2 = player.position + Vector2(0,-36) - message.rect_size/2
		var screen_center: Vector2 = $PlayerCamera.get_camera_screen_center()
		var screen_size: Vector2 = get_viewport().size/2
		screen_size.x *= $PlayerCamera.zoom.x
		screen_size.y *= $PlayerCamera.zoom.y
		message.rect_position.x = clamp(pos.x,  screen_center.x - screen_size.x,
												screen_center.x + screen_size.x -
												message.rect_size.x)
		message.rect_position.y = clamp(pos.y,  screen_center.y - screen_size.y,
												screen_center.y + screen_size.y)



func write(text: String, time: float) -> void:
	message.write(text)
	message_timer.start(time)

func _on_Timer_timeout():
	message.clear()




