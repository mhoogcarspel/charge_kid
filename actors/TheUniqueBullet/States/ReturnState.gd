extends BulletBaseState
class_name ReturnState

onready var player: KinematicBody2D = get_tree().get_nodes_in_group("player")[0]

var velocity: float

func enter():
	owner.get_node("PhysicalCollider").disabled = false
	velocity = owner.velocity
	pass

func update():
	if  Input.is_action_pressed("ui_shoot"):
		velocity = Vector2.ZERO
	else:
		var direction = (player.position - owner.position).normalized()
	
	move_bullet(direction, velocity)


