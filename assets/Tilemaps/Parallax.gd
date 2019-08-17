extends Node2D



export (float) var ratio = 2

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera: Camera2D = player.get_node("PlayerCamera")
onready var on: bool = false


func _ready():
	var timer = Timer.new()
	timer.start(0.1)
	yield(timer, "timeout")
	on = true

func _process(delta):
	if on:
		position.x = camera.get_camera_screen_center().x/ratio - 128


