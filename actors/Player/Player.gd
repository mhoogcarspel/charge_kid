extends KinematicBody2D

export(PackedScene) var bullet

export(bool) var god_mode

export(float) var gravity_acceleration
export(float) var max_fall_speed
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed
export(float) var jump_height
export(float) var shoot_offset
export(float) var boost_distance

var velocity := Vector2()

onready var facing: float = 1
onready var boost_time: float = $AnimationPlayer.get_animation("Boosting").length
onready var boost_speed: float = boost_distance/boost_time
onready var jump_velocity: float = sqrt(2*jump_height*gravity_acceleration)

onready var can_shoot: bool = true
onready var can_boost: bool = true

onready var is_shooting: bool = false
onready var is_jumping: bool = false
onready var is_moving: bool = false
onready var is_boosting: bool = false
onready var just_boosted: bool = false
onready var on_platform: bool = false



func _physics_process(delta):
	
	on_platform = is_on_platform()
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	shoot()
	
	if !is_shooting:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		move(get_directional_inputs(), delta)
		jump()
		damping()
		boost()
		drop()



func damping() -> void:
	velocity.x = clamp(velocity.x, -horizontal_max_speed, horizontal_max_speed)
	velocity.y = clamp(velocity.y, -boost_speed, max_fall_speed)

func move(direction: Vector2, delta: float) -> void:
	if (direction.x*velocity.x > 0 && velocity.x != 0) or (velocity.x == 0 && direction.x != 0):
		velocity.x += direction.x*horizontal_acceleration*delta
		facing = direction.x/abs(direction.x)
		is_moving = true
	
	else:
		if velocity.x > 0:
			velocity.x -= 4*horizontal_acceleration*delta
			velocity.x = clamp(velocity.x, 0, horizontal_max_speed)
		elif velocity.x < 0:
			velocity.x += 4*horizontal_acceleration*delta
			velocity.x = clamp(velocity.x, -horizontal_max_speed, 0)
		else:
			is_moving = false
	
	if !is_boosting:
		velocity.y += gravity_acceleration*delta
		if just_boosted:
			velocity.y += 2*gravity_acceleration*delta
			if velocity.y >= 0:
				just_boosted = false

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
	return directionals

func drop() -> void:
	if Input.is_action_just_pressed("ui_down") && $DropTimer.is_stopped() && is_on_floor() && is_on_platform():
			$CollisionShape2D.disabled = true
			$DropTimer.start()

func _on_DropTimer_timeout():
	$CollisionShape2D.disabled = false

func is_on_platform() -> bool:
	for body in $PlatformSentinel.get_overlapping_bodies():
		if body.is_in_group("platform"):
			return true
	return false

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
		$FeetParticles2.emitting = false
		$FeetParticles3.emitting = false
		velocity = Vector2(0, -boost_speed)
		$BoostTimer.start(boost_time)

func _on_BoostTimer_timeout():
	is_boosting = false
	just_boosted = true

func recharge_fuel() -> void:
	can_boost = true
	$FeetParticles.emitting = true
	$FeetParticles2.emitting = true
	$FeetParticles3.emitting = true



func shoot() -> void:
	if Input.is_action_just_pressed("ui_shoot") && can_shoot:
		var bullet_instance = bullet.instance()
		var bullet_positon = self.position + Vector2(facing*shoot_offset, 0)
		var allow: bool
		if facing < 0:
			allow = check_for_blocks($LeftAreaChecker)
		else:
			allow = check_for_blocks($RightAreaChecker)
		
		if allow:
			bullet_instance.direction = Vector2(facing, 0)
			bullet_instance.position = bullet_positon 
			get_parent().add_child(bullet_instance)
			print("Shooterino MAH FRIEND")
			is_shooting = true
			if !god_mode:
				can_shoot = false
		else:
			$PlayerSprite/ProjectileParticles/ProjectileHit.emitting = true
			yield($PlayerSprite/ProjectileParticles/ProjectileHit, "visibility_changed")
			$PlayerSprite/ProjectileParticles/ProjectileHit.emitting = true

func check_for_blocks(Sensor: Area2D) -> bool:
	for body in Sensor.get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return false
	return true

func hit(projectile: PhysicsBody2D) -> void:
	projectile.velocity = 0
	self.can_shoot = true
	if projectile.fuel_charge_state:
		recharge_fuel()
	print("HIT")
	projectile.destroy()



func is_airborne() -> bool:
	return !self.is_on_floor()










