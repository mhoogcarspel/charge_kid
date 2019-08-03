extends RigidBody2D

export(float) var despawn_timer
export(float) var velocity
export(float) var velocity_fuel
export(float) var distance
export(float) var gravity_accel
export(float) var deflect_velocity

onready var player:KinematicBody2D = get_tree().get_nodes_in_group("player")[0]
onready var direction: Vector2
onready var delta_S := Vector2 ()
onready var standard_state: bool = true
onready var return_state: bool = false
onready var rigid_state: bool = false
onready var interacting: bool = false
onready var fuel_charge_state: bool = false

func _process(delta):
	if standard_state:
		track_distance(delta)
		if !is_interacting():
			if delta_S.length() > distance:
				print("U'e")
				standard_state = false
				return_state = true
		move_bullet()
	if !standard_state:
		if return_state:
			get_player_direction()
			move_bullet()
		else:
			gravity(delta)

func is_interacting() -> bool:
	for body in $HitBox.get_overlapping_bodies():
		if body.is_in_group("interactable"):
			print("Interacting")
			self.distance += 46
			return true
	return false

func activate_rigid_body() -> void:
	$PhysicalCollider.disabled = false

func _on_HitBox_body_entered(body):
	if !body.is_in_group("bullet"):
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
	if body.is_in_group("interactable") && !return_state:
		print("Interactable")
		standard_state = false
		return_state = false
		rigid_state = true
		$PhysicalCollider.set_deferred("disabled", false)
		if (direction.x <= 0):
			linear_velocity = Vector2(-1, -1).normalized()*deflect_velocity
		else:
			linear_velocity = Vector2(1, -1).normalized()*deflect_velocity

func charge_bullet() -> void:
	standard_state = false
	fuel_charge_state = true
	return_state = true
	velocity = velocity_fuel
	$ProjectileParticles.emitting = false
	$FuelChargeParticles.emitting = true
	$FuelChargeParticles/CPUParticles2D.emitting = true

func destroy() -> void:
	$ProjectileParticles.emitting = false
	$FuelChargeParticles.emitting = false
	$FuelChargeParticles/CPUParticles2D.emitting = false
	linear_velocity = Vector2()
	var death_timer = Timer.new()
	get_parent().add_child(death_timer)
	death_timer.start(0.2)
	yield(death_timer, "timeout")
	self.queue_free()
