extends Area2D

export(float) var bullet_velocity
export(float) var distance

onready var direction: Vector2
onready var delta_S: Vector2
onready var return_phase: bool = false
onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if return_phase:
		direction = (player.position - self.position).normalized()
	move(direction, delta)
	if delta_S.length() > distance:
		return_phase = true

func move(direction: Vector2, delta:float):
	self.position += bullet_velocity*direction*delta
	
	if !return_phase:
		self.delta_S += bullet_velocity*direction*delta



func _on_Bullet_body_entered(body):
	body.hit()
	$DespawnTimer.start(0.15)
	yield($DespawnTimer, "timeout")
	if body.is_in_group("player"):
		self.queue_free()
