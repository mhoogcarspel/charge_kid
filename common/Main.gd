extends Node

export(PackedScene) var start_scene
export(PackedScene) var pause_menu
export(PackedScene) var debugger_layer
export(PackedScene) var controls_menu
export(bool) var debugging

onready var actions: Dictionary = {
	"ui_jump": "Jump",
	"ui_shoot": "Shoot",
	"ui_boost": "Boost",
	"ui_bullet_boost": "Bullet Boost",
	"ui_left": "Left",
	"ui_right": "Right",
	"ui_up": "Up",
	"ui_down": "Down",
	"ui_pause": "Pause"
	}

onready var control_handler = ButtonGetter.new(actions)
onready var player_scene: PackedScene = preload("res://actors/Player/Player.tscn")
onready var last_input_device: String = "Keyboard"
onready var controller_layout: String = "Microsoft"

var actual_scene: PackedScene

func _ready():
	if debugging:
		$HudContainer.add_child(debugger_layer.instance())
		pass
	var start = start_scene.instance()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Scene.add_child(start)
	actual_scene = start_scene

func back_to_start():
	change_scene(start_scene)

func change_scene(next_scene: PackedScene) -> void:
	for scene in $Scene.get_children():
		scene.queue_free()
	var scene_instance = next_scene.instance()
	$Scene.call_deferred("add_child", scene_instance)
	actual_scene = next_scene

func _process(delta):
	if Input.is_action_just_pressed("ui_pause") and !get_tree().get_nodes_in_group("player").empty() and !get_tree().paused:
		$HudContainer.add_child(pause_menu.instance())

func _input(event):
	if event is InputEventKey:
		last_input_device = "Keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_device = "Controller"

func is_using_keyboard() -> bool:
	if last_input_device == "Keyboard":
		return true
	else:
		return false

func is_using_controller() -> bool:
	if last_input_device == "Controller":
		return true
	else:
		return false



