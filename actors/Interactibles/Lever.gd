extends Sprite

func hit(projectile:Area2D):
	for object in  $Linked.get_children():
		toggle(object)

func toggle(object:Node) -> void:
	if object.is_active:
		object.deactivate()
	else:
		object.activate()