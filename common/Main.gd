extends Node

export(PackedScene) var start_scene

var actual_scene: PackedScene

func _ready():
	var start = start_scene.instance()
	add_child(start)
	actual_scene = start_scene

func _process(delta):
	if Input.is_action_just_released("ui_reset") && get_tree().get_nodes_in_group("player").size() > 0:
		change_scene(actual_scene) #Reset function
		pass

func back_to_start():
	change_scene(start_scene)

func change_scene(next_scene: PackedScene) -> void:
	for scene in self.get_children():
		scene.queue_free()
	var scene_instance = next_scene.instance()
	self.call_deferred("add_child", scene_instance)
	actual_scene = next_scene
	 