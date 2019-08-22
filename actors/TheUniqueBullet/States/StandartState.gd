extends BulletBaseState
class_name StandartState

var velocity: float = owner.velocity
var direction: Vector2 = owner.direction
var range_distance: float
var delta_S:= Vector2()

func enter():
	owner.get_node("PhysicalCollider").disabled = false
	velocity = owner.velocity
	direction = owner.direction
	delta_S = Vector2()
	range_distance = owner.range_distance

func update():
	if delta_S.length() > range_distance or check_for_collisions_with_blocks():
		#Go to return state
		pass
	move_bullet(direction, velocity)
	pass

func track_distance(delta: float) -> void:
	delta_S += velocity*direction*delta

func check_for_collisions_with_blocks() -> bool:
	for body in owner.get_node("HitBox").get_overlapping_bodies():
		if body.is_in_group("block"):
			return true
	return false