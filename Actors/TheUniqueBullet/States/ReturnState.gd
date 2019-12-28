extends BulletBaseState
class_name ReturnState

var speed: float
var direction: Vector2
var player: KinematicBody2D

func _init(owner: Node, player_node):
	self.owner = owner
	self.player = player_node

func enter():
	owner.get_node("PhysicalCollider").set_deferred("disabled", false)
	speed = 0

func update(delta):
	if  Input.is_action_pressed("ui_shoot"):
		owner.change_state("HoldState")
	else:
		direction = (player.position - owner.position).normalized()
		speed += delta*owner.return_acceleration
		speed = clamp(speed, 0, owner.return_speed)
	
	move_bullet(direction, speed)


