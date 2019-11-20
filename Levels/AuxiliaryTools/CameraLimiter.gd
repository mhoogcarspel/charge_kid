extends Area2D

export (int) var limit
var camera_center: Node2D



func _ready():
	camera_center = Node2D.new()
	get_parent().call_deferred("add_child", camera_center)
	camera_center.position.x = 256 + limit



func _on_CameraSetter_body_entered(body):
	if body.is_in_group("player"):
		if not get_tree().get_nodes_in_group("camera").empty():
			var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
			camera.followed_node = camera_center
			camera.drag_margin_left = 0.0
			camera.drag_margin_right = 0.0

#		if body.get_node_or_null("PlayerCamera") != null:
#			var camera: Camera2D = body.get_node("PlayerCamera")
#			body.remove_child(camera)
#			camera_center.add_child(camera)
#			camera.drag_margin_left = 0.0
#			camera.drag_margin_right = 0.0
#			camera.zoom = Vector2(0.5,0.5)

func _on_CameraSetter_body_exited(body):
	if body.is_in_group("player"):
		var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
		if camera != null:
			if camera.player_is_alive:
				camera.followed_node = body
				camera.drag_margin_left = 0.2
				camera.drag_margin_right = 0.2

#		if camera_center.get_node_or_null("PlayerCamera") != null:
#			var camera: Camera2D = camera_center.get_node("PlayerCamera")
#			camera_center.remove_child(camera)
#			body.add_child(camera)
#			camera.drag_margin_left = 0.2
#			camera.drag_margin_right = 0.2
#			camera.zoom = Vector2(0.5,0.5)



