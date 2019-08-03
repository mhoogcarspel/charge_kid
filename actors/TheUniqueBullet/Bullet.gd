extends RigidBody2D

export(float) var despawn_timer
export(float) var velocity
export(float) var distance
export(float) var gravity_accel
export(float) var deflect_velocity

onready var player:KinematicBody2D = get_tree().get_nodes_in_group("player")[0]
onready var direction: Vector2
onready var delta_S := Vector2 ()
onready var standart_state: bool = true
onready var return_state: bool = false
onready var rigid_state: bool = false

func _physics_process(delta):
	if standart_state:
		track_distance(delta)
		if delta_S.length() > distance:
			standart_state = false
			return_state = true
		move_bullet()
	if !standart_state:
		if return_state:
			get_player_direction()
			move_bullet()
		else:
			gravity(delta)

func activate_rigid_body() -> void:
	$PhysicalCollider.disabled = false

func _on_HitBox_body_entered(body):
	if !body.is_in_group("bullet"):
		$DespawnTimer.start(despawn_timer)
		yield($DespawnTimer, "timeout")
		body.hit(self)

func move_bullet() -> void:
	linear_velocity = direction*velocity

func track_distance(delta: float) -> void:
	delta_S += velocity*direction*delta

func get_player_direction() -> void:
	direction = (player.position - self.position).normalized()

func gravity(delta: float) -> void:
	linear_velocity.y +=  gravity_accel*delta

func _on_HitBox_body_exited(body):
	if body.is_in_group("interactable"):
		print("Interactable")
		standart_state = false
		return_state = false
		rigid_state = true
		$PhysicalCollider.set_deferred("disabled", false)
		if (direction.x <= 0):
			linear_velocity = Vector2(-1, -1).normalized()*deflect_velocity
		else:
			linear_velocity = Vector2(1, -1).normalized()*deflect_velocity
		
		pass
