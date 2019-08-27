extends State
class_name BulletBaseState

func activate_rigid_body() -> void:
	owner.get_node("PhysicalCollider").disabled = false

func move_bullet(direction:Vector2, velocity:float) -> void:
	owner.linear_velocity = direction*velocity