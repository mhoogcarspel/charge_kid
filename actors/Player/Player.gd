extends KinematicBody2D

export(PackedScene) var bullet

export(bool) var god_mode

export(float) var gravity_acceleration
export(float) var max_fall_speed
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed
export(float) var jump_velocity
export(float) var shoot_offset
export(float) var boost_distance

var velocity := Vector2()

onready var facing: float = 1
onready var boost_time: float = $AnimationPlayer.get_animation("Boosting").length
onready var boost_speed: float = boost_distance/boost_time

onready var can_shoot: bool = true
onready var can_boost: bool = true

onready var is_shooting: bool = false
onready var is_jumping: bool = false
onready var is_moving: bool = false
onready var is_boosting: bool = false



func _physics_process(delta):
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	shoot()
	
	if !is_shooting:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		move(get_directional_inputs(), delta)
		jump()
		damping()
		boost()
	


func damping() -> void:
	velocity.x = clamp(velocity.x, -horizontal_max_speed, horizontal_max_speed)
	velocity.y = clamp(velocity.y, -boost_speed, max_fall_speed)

func move(direction: Vector2, delta: float) -> void:
	if direction.x != 0:
		velocity.x += direction.x*horizontal_acceleration*delta
		facing = direction.x/abs(direction.x)
		is_moving = true
	
	else:
		velocity.x = 0
		is_moving = false
	
	if !is_boosting:
		velocity.y += gravity_acceleration*delta

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
	return directionals


func jump() -> void:
	if !$CoyoteTimer.is_stopped() && Input.is_action_just_pressed("ui_jump") && !is_jumping && !is_boosting:
		print("JUMP MAH FRIEND")
		velocity.y = -jump_velocity
		is_jumping = true
		
	if Input.is_action_just_released("ui_jump") && velocity.y < 0:
		velocity.y = 0
	
	if velocity.y >= 0 and is_jumping:
		is_jumping = false



func boost() -> void:
	if can_boost && Input.is_action_just_pressed("ui_boost") && !is_boosting:
		is_boosting = true
		can_boost = false
		$FeetParticles.emitting = false
		velocity = Vector2(0, -boost_speed)
		$BoostTimer.start(boost_time)
		gravity_acceleration = 0.0

func _on_BoostTimer_timeout():
	is_boosting = false

func recharge_fuel() -> void:
	can_boost = true
	$FeetParticles.emitting = true



func shoot() -> void:
	if Input.is_action_just_pressed("ui_shoot") && can_shoot:
		var bullet_instance = bullet.instance()
		bullet_instance.direction = Vector2(facing, 0)
		bullet_instance.position = self.position + Vector2(facing*shoot_offset, 0)
		get_parent().add_child(bullet_instance)
		print("Shooterino MAH FRIEND")
		is_shooting = true
		
		if !god_mode:
			can_shoot = false



func hit(projectile: PhysicsBody2D) -> void:
	projectile.velocity = 0
	self.can_shoot = true
	print("HIT")
	projectile.destroy()



func is_airborne() -> bool:
	return !self.is_on_floor()









