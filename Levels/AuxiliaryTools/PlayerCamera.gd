extends Camera2D
class_name PlayerCamera

var followed_node: Node2D

onready var dissipation: float = 0.0
onready var shake_amplitude: float = 0.0
onready var shake_direction: int = 1
onready var player_is_alive: bool = true



func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	followed_node = player
	yield(get_tree(), "physics_frame")
	limit_right = get_tree().get_nodes_in_group("level")[0].level_length

func _physics_process(delta):
	if is_instance_valid(followed_node) and followed_node != null:
		self.position = followed_node.position
#		print(followed_node.name)
	else:
		if not get_tree().get_nodes_in_group("player").empty():
			followed_node = get_tree().get_nodes_in_group("player")[0]
	
	# Dealing with screen shakes
	if shake_amplitude > 0:
# warning-ignore:narrowing_conversion
		limit_left = -shake_amplitude
		limit_right = get_tree().get_nodes_in_group("level")[0].level_length + shake_amplitude
		
		shake_amplitude = clamp(shake_amplitude - delta*dissipation, 0, 1000)
		
		if shake_amplitude > 4:
			offset.x += 4*delta*dissipation*shake_direction
			while abs(offset.x) > shake_amplitude:
				if offset.x > shake_amplitude:
					offset.x = shake_amplitude - (offset.x - shake_amplitude)
					shake_direction = -1
				elif offset.x < -shake_amplitude:
					offset.x = -shake_amplitude + (-offset.x - shake_amplitude)
					shake_direction = 1
		else:
			shake_amplitude = 0
			limit_left = 0
			limit_right = get_tree().get_nodes_in_group("level")[0].level_length
		
	elif offset.x != 0:
		offset.x = 0.0

func shake_screen(magnitude: float) -> void:
	shake_direction = 1
	shake_amplitude = magnitude
	dissipation = magnitude*4



func player_just_spawned() -> void:
	player_is_alive = true

func player_just_died() -> void:
	player_is_alive = false


