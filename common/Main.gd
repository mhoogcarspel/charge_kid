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
	"left": "Left",
	"right": "Right",
	"up": "Up",
	"down": "Down",
	"ui_pause": "Pause"
	}

onready var control_handler = ButtonGetter.new(actions)
onready var old_dir_input: Vector2 = Vector2.ZERO
onready var actual_dir_input: Vector2 = Vector2.ZERO
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
	get_tree().paused = false
	for scene in $Scene.get_children():
		scene.queue_free()
	var scene_instance = next_scene.instance()
	$Scene.call_deferred("add_child", scene_instance)
	actual_scene = next_scene

func _process(delta):
	# Pausing
	if Input.is_action_just_pressed("ui_pause") and !get_tree().get_nodes_in_group("player").empty() and !get_tree().paused and $PauseTimer.is_stopped():
		get_tree().paused = true
		$HudContainer.add_child(pause_menu.instance())
		$PauseTimer.start()
	
	#Unpausing
	if Input.is_action_just_pressed("ui_pause") and !get_tree().get_nodes_in_group("player").empty() and get_tree().paused and $PauseTimer.is_stopped():
		get_tree().paused = false
		get_tree().get_nodes_in_group("pause_menu")[0].queue_free()
		$PauseTimer.start()
	
	# Timer for menu navigating
	actual_dir_input = control_handler.get_directional_input()
	if get_tree().paused and actual_dir_input.y != 0 and old_dir_input.y == 0:
		$MenuNavTimer/Timer.start()
	if get_tree().paused and actual_dir_input.y == 0 and old_dir_input.y != 0:
		$MenuNavTimer.stop()
	old_dir_input = control_handler.get_directional_input()

func _on_Timer_timeout():
	$MenuNavTimer.start()



### DETECT WHICH DEVICE THE PLAYER IS USING #######################################
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
###################################################################################






