extends BulletBaseState
class_name StoppedState



func _init(owner: Node):
	self.owner = owner

func update(delta):
	move_bullet(Vector2.ZERO, 0)


