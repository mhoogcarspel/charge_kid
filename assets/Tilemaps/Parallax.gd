extends Node2D



export (float) var ratio = 2

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera: Camera2D = player.get_node("PlayerCamera")



func _process(delta):
	player = get_tree().get_nodes_in_group("player")[0]
	if player != null:
		camera = player.get_node("PlayerCamera")
	if camera != null:
		position.x = camera.get_camera_screen_center().x/ratio - 128



