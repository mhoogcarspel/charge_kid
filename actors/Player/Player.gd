extends KinematicBody2D

export(PackedScene) var bullet

export(bool) var god_mode
export(bool) var has_projectile
export(bool) var has_fuel
export(float) var level_length

export(float) var gravity_acceleration
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed
export(float) var jump_height
export(float) var shoot_offset
export(float) var boost_distance
export(float) var boost_time

var velocity := Vector2()

onready var facing: float = 1
onready var boost_speed: float = boost_distance/boost_time
onready var jump_velocity: float = sqrt(2*jump_height*gravity_acceleration)
onready var max_fall_speed: float = jump_velocity

var can_shoot: bool
var can_boost: bool
var checkpoint: Vector2
var pre_checkpoint: Vector2

onready var is_shooting: bool = false
onready var is_jumping: bool = false
onready var is_moving: bool = false
onready var is_boosting: bool = false
onready var is_bullet_boosting: bool = false
onready var just_boosted: bool = false
onready var just_bullet_boosted: bool = false
onready var on_platform: bool = false
onready var label_time: float = 2.0
onready var boost_velocity: Vector2 = Vector2.ZERO
onready var is_dying: bool = false


func _ready():
	can_shoot = has_projectile
	
	$PlayerCamera.limit_right = level_length
	
	if has_fuel:
		can_boost = true
	else:
		can_boost = false
		$FeetParticles.emitting = false
		$FeetParticles2.emitting = false
		$FeetParticles3.emitting = false
	
	if get_node_or_null("PlayerCamera") != null:
		$PlayerCamera.current = true

func _physics_process(delta):
	
	if not is_dying:
		on_platform = is_on_platform()
		
		if is_on_floor():
			$CoyoteTimer.start()
		
		shoot()
		
		if !is_shooting:
			velocity = move_and_slide(velocity, Vector2(0,-1))
			
			# If you touch a wall during a bullet jump, this code puts the velocity back
			# in the direction of the bullet
			if is_bullet_boosting and boost_velocity != velocity:
				var bullet = get_tree().get_nodes_in_group("bullet")[0]
				var relative_position = (bullet.position - self.position)
				velocity = relative_position.normalized()*boost_velocity.length()
				boost_velocity = velocity
			
			move(get_directional_inputs(), delta)
			jump()
			boost()
			drop()
		
		# Checkpoint setter.
		if is_on_floor():
			pre_checkpoint = position



func move(direction: Vector2, delta: float) -> void:
	if !is_bullet_boosting:
		if (direction.x*velocity.x > 0) or (velocity.x == 0 && direction.x != 0):
			velocity.x += direction.x*horizontal_acceleration*delta
			velocity.x = clamp(velocity.x, -horizontal_max_speed, horizontal_max_speed)
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
	
	if just_bullet_boosted:
		if velocity.x > 0:
			velocity.x += 3*horizontal_acceleration*delta
			velocity.x = clamp(velocity.x, 0, horizontal_max_speed)
		elif velocity.x < 0:
			velocity.x -= 3*horizontal_acceleration*delta
			velocity.x = clamp(velocity.x, -horizontal_max_speed, 0)
		velocity.y += 2*gravity_acceleration*delta
		if velocity.y >= 0:
			just_bullet_boosted = false
	
	if !is_boosting:
		velocity.y += gravity_acceleration*delta
		if just_boosted:
			velocity.y += 2*gravity_acceleration*delta
			if velocity.y >= 0:
				just_boosted = false
				$BoostParticles1.emitting = false
		velocity.y = clamp(velocity.y, -30000, max_fall_speed)

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					0 )
	return directionals



func drop() -> void:
	if Input.is_action_just_pressed("ui_down") && $DropTimer.is_stopped() && is_on_floor() && is_on_platform():
		self.set_collision_mask_bit(1,false)
		$DropTimer.start()

func _on_DropTimer_timeout():
	self.set_collision_mask_bit(1,true)

func is_on_platform() -> bool:
	for body in $PlatformSentinel.get_overlapping_bodies():
		if body.is_in_group("platform"):
			return true
	return false



func jump() -> void:
	if !$CoyoteTimer.is_stopped() && Input.is_action_just_pressed("ui_jump") && !is_jumping && !is_boosting:
		$SFX/Jump.play()
		velocity.y = -jump_velocity
		is_jumping = true
		$CoyoteTimer.stop()
		
	if Input.is_action_just_released("ui_jump") && velocity.y < 0 && !is_boosting:
		velocity.y /= 4
	
	if velocity.y >= 0 and is_jumping:
		is_jumping = false



func boost() -> void:
	if can_boost && Input.is_action_just_pressed("ui_boost") && !is_boosting:
		
		### BULLET BOOST ######################################################################
		if is_holding_bullet() or is_bullet_boosting:
			var bullet = get_tree().get_nodes_in_group("bullet")[0]
			var relative_position = (bullet.position - self.position)
			is_bullet_boosting = true
			
			# Calculating boost time. Boost speed must be at least equal to normal boost speed and at
			# most equal to two times normal boost speed.
			
			# First case: projectile is close enough to have a shorter boost time with normal boost speed.
			if relative_position.length()/boost_time < boost_speed:
				velocity = relative_position.normalized()*boost_speed
				$BoostTimer.start(relative_position.length()/boost_speed)
				
			# Second case: projectile is too far to have normal speed but too close to double speed.
			elif relative_position.length()/boost_time < 2*boost_time:
				velocity = relative_position/boost_time
				$BoostTimer.start(boost_time)
				
			# Final case: projectile is far enough for double speed and more than normal boost time.
			else:
				velocity = relative_position.normalized()*2*boost_speed
				$BoostTimer.start(relative_position.length()/(2*boost_speed))
		#######################################################################################
		
		### NORMAL BOOST ######################################################################
		else:
			velocity = Vector2(0, -boost_speed)
			$BoostTimer.start(boost_time)
		#######################################################################################
		
		boost_velocity = velocity
		$SFX/SuperJump.play()
		is_boosting = true
		can_boost = false
		is_jumping = false
		$FeetParticles.emitting = false
		$FeetParticles2.emitting = false
		$FeetParticles3.emitting = false
		$BoostParticles1.emitting = true
		$BoostParticles2.emitting = true
		$BoostParticles3.emitting = true
		$BoostParticles4.emitting = true

func _on_BoostTimer_timeout():
	is_boosting = false
	if is_bullet_boosting:
		is_bullet_boosting = false
		just_bullet_boosted = true
		$BoostParticles1.emitting = false
	else:
		just_boosted = true

func recharge_fuel() -> void:
	$SFX/FuelPickup.play()
	can_boost = true
	$FeetParticles.emitting = true
	$FeetParticles2.emitting = true
	$FeetParticles3.emitting = true

func is_holding_bullet() -> bool:
	if get_tree().get_nodes_in_group("bullet").size() > 0:
		var bullet = get_tree().get_nodes_in_group("bullet")[0]
		if bullet.stack[0] == "HoldState":
			return true
		else:
			return false
	else:
		return false



func shoot() -> void:
	if Input.is_action_just_pressed("ui_shoot") && can_shoot:
		$SFX/Shoot.play()
		var bullet_instance = bullet.instance()
		var bullet_positon = self.position + Vector2(facing*shoot_offset, 0)
		var allow: bool
		velocity = Vector2.ZERO
		
		if facing < 0:
			allow = check_for_blocks($LeftAreaChecker)
		else:
			allow = check_for_blocks($RightAreaChecker)
		
		if allow:
			bullet_instance.direction = Vector2(facing, 0)
			bullet_instance.position = bullet_positon 
			bullet_instance.initial_state = "StandardState"
			get_parent().add_child(bullet_instance)
			is_shooting = true
			if !god_mode:
				can_shoot = false



func check_for_blocks(Sensor: Area2D) -> bool:
	for body in Sensor.get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return false
	return true

func hit(projectile: PhysicsBody2D) -> void:
	match projectile.stack[0]:
		"StandingState":
			$SFX/BulletPickup.play()
		"FuelChargeState":
			recharge_fuel()
		
	projectile.velocity = 0
	self.can_shoot = true
	if is_bullet_boosting:
		$BoostTimer.stop()
		_on_BoostTimer_timeout()
	projectile.destroy()



func is_airborne() -> bool:
	return !self.is_on_floor()



func write(text: String, factor: float = 1.0) -> void:
	$Label.set_text(text)
	$LabelTimer.start(label_time*factor)

func _on_LabelTimer_timeout():
	$Label.set_text(" ")

func _on_SpikesSentinel_body_entered(body):
	if body.is_in_group("spikes"):
		kill()

func kill() -> void:
	is_dying = true
	$SFX/Death.play()
	$PlayerSprite.visible = false
	$DeathParticles.emitting = true
	$FeetParticles.emitting = false
	$FeetParticles2.emitting = false
	$FeetParticles3.emitting = false
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.5)
	yield(timer, "timeout")
	reset()

func reset() -> void:
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var next_player = main.player_scene.instance()
		next_player.position = checkpoint
		next_player.level_length = self.level_length
		
		if get_tree().get_nodes_in_group("bullet").size() > 0:
			get_tree().get_nodes_in_group("bullet")[0].queue_free()
		
		get_parent().add_child(next_player)
		self.queue_free()
	else:
		get_tree().reload_current_scene()


