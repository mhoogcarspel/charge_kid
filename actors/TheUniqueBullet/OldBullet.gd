extends Area2D

export(float) var bullet_velocity
export(float) var distance
export(float) var gravity_value

onready var gravity_acceleration: float = 0
onready var direction: Vector2
onready var delta_S: Vector2
onready var return_phase: bool = false
onready var bouncy_phase: bool = false
onready var solid_state: bool = false
onready var player:KinematicBody2D = get_tree().get_nodes_in_group("player")[0]
onready var velocity: Vector2

func _physics_process(delta):
	if return_phase:
		return_to_player(delta, player)
	elif bouncy_phase:
		bounce(direction, delta)
	else:
		standart_phase(direction, delta)
	
	if delta_S.length() > distance:
		return_phase = true

func move(direction: Vector2, delta:float) -> void:
	self.position += bullet_velocity*direction*delta

func track_distance(direction: Vector2, delta:float) -> void:
		self.delta_S += bullet_velocity*direction*delta

func standart_phase(direction: Vector2, delta:float) -> void:
	move(direction, delta)
	track_distance(direction, delta)

func return_to_player(delta:float, player:KinematicBody2D) -> void:
	direction = (player.position - self.position).normalized()
	move(direction, delta)

func bounce(direction: Vector2, delta:float) -> void:
	velocity = Vector2(0, 2*gravity_acceleration*delta) + direction*bullet_velocity
	position += Vector2(0, gravity_acceleration*delta*delta) + direction*bullet_velocity*delta



func _on_Bullet_body_entered(body):
	$DespawnTimer.start(0.15)
	yield($DespawnTimer, "timeout")
	body.hit(self)


func _on_Bullet_body_exited(body):
	if body.is_in_group("interactable") && self.bouncy_phase && !self.solid_state:
		print("Foi")
		self.solid_state = true
