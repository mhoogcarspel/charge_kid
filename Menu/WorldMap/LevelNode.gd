extends ButtonModel
class_name LevelNode

export(bool) var initially_open
export(PackedScene) var level_scene

var world_map

export(Dictionary) var neighbour_path = {
	"Up": null,
	"Down": null,
	"Left": null,
	"Right": null
	}

export(Dictionary) var children = {
	"Up": false,
	"Down": false,
	"Left": false,
	"Right": false
	}

onready var path: NodePath

var is_open: bool
var cleared: bool

func _ready():
	self.is_open = self.initially_open
	self.path = get_path()

func _process(delta):
	self.disabled = !self.is_open

func clear_level(direction: String = "All") -> void:
	print("Clear")
	match direction:
		"All":
			for children_direction in children.keys():
				if children[children_direction]:
					var node_level: LevelNode = get_node(neighbour_path[children_direction])
					node_level.open_level(self, children_direction)
		_:
			if direction in children.keys() and children[direction]:
				var node_level: LevelNode = get_node(neighbour_path[direction])
				node_level.open_level(self, direction)
			else:
				print("ERROR: Invalid direction on function clear_level")
		
	if !self.is_inside_tree():
		yield(self, "tree_entered")
	world_map.save_game()
	self.grab_focus()




func open_level(parent: LevelNode, direction_from_parent : String) -> void:
	if !self.is_inside_tree():
		yield(self, "tree_entered")
	self.is_open = true
	match direction_from_parent:
		"Up":
			self.focus_neighbour_bottom = parent.path
			parent.focus_neighbour_top = self.path
		"Down":
			self.focus_neighbour_top = parent.path
			parent.focus_neighbour_bottom = self.path
		"Left":
			self.focus_neighbour_right = parent.path
			parent.focus_neighbour_left = self.path
		"Right":
			self.focus_neighbour_left = parent.path
			parent.focus_neighbour_right = self.path

func save() -> Dictionary:
	var save_dict: Dictionary = {
		"is_open": is_open,
		"cleared": cleared,
		"focus_neighbour_right": focus_neighbour_right,
		"focus_neighbour_left": focus_neighbour_left,
		"focus_neighbour_top": focus_neighbour_top,
		"focus_neighbour_bottom": focus_neighbour_bottom
		}
	return save_dict
	pass

func _on_LevelNode_pressed():
	main.change_scene(level_scene).level_node = self
