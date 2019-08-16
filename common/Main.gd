extends Node

export(PackedScene) var start_scene
export(PackedScene) var pause_menu

onready var actions: Dictionary = {
	"ui_jump": "Jump",
	"ui_shoot": "Shoot",
	"ui_boost": "Boost",
	"ui_left": "Left",
	"ui_right": "Right",
	"ui_up": "Up",
	"ui_down": "Down",
	"ui_pause": "Pause/Back"
	}

onready var control_handler = ButtonGetter.new(actions)

var actual_scene: PackedScene

func _ready():
	var start = start_scene.instance()
	add_child(start)
	actual_scene = start_scene

func back_to_start():
	change_scene(start_scene)

func change_scene(next_scene: PackedScene) -> void:
	for scene in self.get_children():
		scene.queue_free()
	var scene_instance = next_scene.instance()
	self.call_deferred("add_child", scene_instance)
	actual_scene = next_scene

func _process(delta):
	if Input.is_action_just_pressed("ui_pause") and !get_tree().get_nodes_in_group("player").empty():
		self.add_child(pause_menu.instance())