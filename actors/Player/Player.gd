extends KinematicBody2D

export(bool) var god_mode
export(float) var level_length

export(PackedScene) var bullet
export(float) var shoot_offset

export(float) var label_time
export(float) var factor

export(bool) var has_bullet

export(float) var horizontal_acceleration
export(float) var max_horizontal_velocity
export(float) var deacceleration_horizontal_velocity

export(float) var boost_distance
export(float) var boost_time
onready var boost_speed:float = boost_distance/boost_time

export(float) var coyote_time
export(float) var bunny_time
export(float) var jump_height
export(float) var gravity_acceleration

onready var jump_velocity = sqrt(2*jump_height*gravity_acceleration)
onready var max_falling_velocity: float = jump_velocity
onready var velocity: Vector2

onready var states: Dictionary = {
	"IdleState" : IdleState.new(self),
	"MovingState" : MovingState.new(self),
	"OnAirState" : OnAirState.new(self),
	"JumpingState" : JumpingState.new(self),
	"ShootingState" : ShootingState.new(self),
	"BoostingState" : BoostingState.new(self),
	"BulletBoostingState": BulletBoostingState.new(self),
	"DyingState" : DyingState.new(self)
	}
onready var actual_state: String
onready var stack: Array = []

onready var can_boost:bool
onready var facing:float = 1

var checkpoint: Vector2
var pre_checkpoint: Vector2

func _ready():
	$PlayerCamera.limit_right = level_length
	print("jump_velocity:")
	print(jump_velocity)
	stack.push_front("IdleState")

func _physics_process(delta):
	actual_state = stack[0]
	states[actual_state].update(delta)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if is_on_floor():
		pre_checkpoint = position

func change_state(state: String):
	var previous_state = stack[0]
	match state:
		"IdleState":
			while(stack[0] != "IdleState"):
				stack.pop_front()
		"MovingState":
			stack.push_front(state)
		"ShootingState":
			stack.push_front(state)
		"OnAirState":
			stack.push_front(state)
		"JumpingState":
			if previous_state == "JumpingState" || previous_state == "OnAirState":
				stack.pop_front()
			stack.push_front(state)
		"BoostingState","BulletBoostingState":
			if previous_state == "JumpingState"|| previous_state == "BoostingState" || previous_state == "BulletBoostingState":
				states[stack[0]].exit()
				stack.pop_front()
			stack.push_front(state)
		"DyingState":
			while(!stack.empty()):
				states[stack[0]].exit()
				stack.pop_front()
			stack.push_front(state)
	states[previous_state].exit()
	states[state].enter()
	print(state)
	print(stack)

func pop_state():
	print(stack)
	states[stack[0]].exit()
	self.stack.pop_front()
	print(stack)

func horizontal_move(direction: Vector2, delta: float, factor: float = 1.0, dissipation: bool = true) -> void:
	if direction.x != 0:
		velocity += direction*delta*horizontal_acceleration*factor
	elif velocity.x != 0 && dissipation:
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= velocity.x/abs(velocity.x) * deacceleration_horizontal_velocity * delta
		if signal_velocity != velocity.x/abs(velocity.x):
			velocity.x = 0
	velocity.x = clamp(velocity.x, -max_horizontal_velocity, max_horizontal_velocity)
	return

func gravity(delta: float, factor: float = 1):
	self.velocity.y += gravity_acceleration*delta*factor
	if self.velocity.y > max_falling_velocity:
		self.velocity.y = max_falling_velocity

func jump():
	$SFX/Jump.play()
	self.velocity.y = -jump_velocity

func is_on_platform() -> bool:
	for body in $PlatformSentinel.get_overlapping_bodies():
		if body.is_in_group("platform"):
			return true
	return false
	
func write(text: String, factor: float = 1.0) -> void:
	$Label.set_text(text)
	$LabelTimer.start(label_time*factor)

func _on_LabelTimer_timeout():
	$Label.set_text(" ")

func hit(projectile: PhysicsBody2D) -> void:
	match projectile.stack[0]:
		"StandingState":
			$SFX/BulletPickup.play()
		"FuelChargeState":
			recharge_fuel()
		
	projectile.velocity = 0
	self.has_bullet = true
	if stack[0] == "BulletBoostingState":
		$BoostTimer.stop()
		_on_BoostTimer_timeout()
	projectile.destroy()

func recharge_fuel() -> void:
	$SFX/FuelPickup.play()
	can_boost = true
	$FeetParticles.emitting = true
	$FeetParticles2.emitting = true
	$FeetParticles3.emitting = true

func _on_BoostTimer_timeout():
	#is_boosting = false
	if actual_state == "BulletBoostingState":
		#is_bullet_boosting = false
		#just_bullet_boosted = true
		$BoostParticles1.emitting = false
#	else:
#		just_boosted = true

func shoot() -> void:
	if Input.is_action_just_pressed("ui_shoot") && has_bullet:
		$AnimationPlayer.play("Shooting")
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
			if !god_mode:
				has_bullet = false

func check_for_blocks(Sensor: Area2D) -> bool:
	for body in Sensor.get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return false
	return true

func drop() -> void:
	if Input.is_action_just_pressed("ui_down") && $DropTimer.is_stopped() && is_on_floor() && is_on_platform():
		self.set_collision_mask_bit(1,false)
		$DropTimer.start()

func _on_DropTimer_timeout():
	self.set_collision_mask_bit(1,true)

func _on_SpikesSentinel_body_entered(body):
	if body.is_in_group("spikes"):
		change_state("DyingState")

func kill() -> void:
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