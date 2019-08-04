extends Node

export(PackedScene) var start_scene

func _ready():
	var start = start_scene.instance()
	add_child(start)

func back_to_start():
	change_scene(start_scene)

func change_scene(next_scene: PackedScene) -> void:
	for scene in self.get_children():
		scene.queue_free()
	var scene_instance = next_scene.instance()
	self.add_child(scene_instance)
	 