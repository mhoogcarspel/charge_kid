extends BulletBaseState
class_name ReturnState

var speed: float
var direction: Vector2
var player: KinematicBody2D

func _init(owner: Node, player):
	self.owner = owner
	self.player = player

func enter():
	owner.get_node("PhysicalCollider").set_deferred("disabled", false)
	speed = owner.return_speed

func update(delta):
	if  Input.is_action_pressed("ui_shoot"):
		owner.change_state("HoldState")
	else:
		direction = (player.position - owner.position).normalized()
	
	move_bullet(direction, speed)


