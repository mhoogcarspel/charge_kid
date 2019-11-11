extends KinematicBody2D
class_name Player

export(bool) var god_mode

export(PackedScene) var bullet
export(float) var shoot_offset

export(float) var label_time
export(float) var factor

export(bool) var has_bullet

export(float) var acceleration
export(float) var speed
export(float) var friction
export(float) var air_friction

export(float) var boost_distance
export(float) var boost_time
onready var boost_speed: float = boost_distance/boost_time

export(float) var coyote_time
export(float) var bunny_time
export(float) var jump_height
export(float) var gravity

var main
var control_handler

onready var jump_speed = sqrt(2*jump_height*gravity)
onready var falling_speed: float = jump_speed
onready var velocity: Vector2

onready var states: Dictionary = {
	"IdleState" : IdleState.new(self),
	"MovingState" : MovingState.new(self),
	"OnAirState" : OnAirState.new(self),
	"JumpingState" : JumpingState.new(self),
	"ShootingState" : ShootingState.new(self),
	"BoostingState" : BoostingState.new(self),
	"BulletBoostingState": BulletBoostingState.new(self),
	"DyingState" : DyingState.new(self),
	"StatelessState" : StatelessState.new(self)
	}

onready var stack: Array = []
onready var animation_player = $AnimationPlayer

onready var can_boost: bool
onready var facing: float = 1.0

var checkpoint: Vector2
var pre_checkpoint: Vector2



func _ready():
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
		control_handler = main.control_handler
	else:
		var actions: Dictionary = {
		"ui_jump": "Jump",
		"ui_shoot": "Shoot",
		"ui_boost": "Boost",
		"ui_bullet_boost": "Bullet Boost",
		"left": "Left",
		"right": "Right",
		"up": "Up",
		"down": "Down",
		"ui_pause": "Pause"
		}
		control_handler = ButtonGetter.new(actions)
	stack.push_front("IdleState")
	
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.1)
	yield(timer, "timeout")
	timer.queue_free()
	var camera = get_tree().get_nodes_in_group("camera")[0]
	camera.player_just_spawned()
	
	$LeftAreaChecker.position += Vector2(-shoot_offset,0)
	$RightAreaChecker.position += Vector2(shoot_offset,0)



func _physics_process(delta):
	states[get_state()].update(delta)
	
	if get_state() != "DyingState" and get_state() != "StatelessState":
		velocity = move_and_slide(velocity, Vector2(0, -1))
		if is_on_floor():
			$CoyoteTimer.start(coyote_time)
			pre_checkpoint = position
		
		if Input.is_action_just_pressed("ui_reset"):
			change_state("DyingState")



func change_state(state: String):
	var previous_state = stack[0]
	
	var was_airborne: bool = false
	if previous_state == "JumpingState" or previous_state == "OnAirState":
		was_airborne = true
	elif previous_state == "BoostingState" or previous_state == "BulletBoostingState":
		was_airborne = true
	
	match state:
		"IdleState":
			while(stack[0] != "IdleState"):
				stack.pop_front()
			if was_airborne:
				$AnimationPlayer.play("Landing")
		"MovingState":
			while(stack[0] != "IdleState" and stack[0] != "MovingState"):
				stack.pop_front()
			if stack[0] == "IdleState":
				stack.push_front(state)
			if was_airborne:
				$AnimationPlayer.play("Landing")
		_:
			stack.push_front(state)
	
	states[previous_state].exit()
	states[state].enter()

func pop_state():
	change_state("IdleState")

func get_state() -> String:
	return stack[0]



func horizontal_move(direction: Vector2, delta: float,
					factor: float = 1.0, air_brake: bool = false):
	if direction.x != 0:
		velocity += direction*delta*acceleration*factor
	elif velocity.x != 0:
		var deacceleration = friction
		if air_brake:
			deacceleration = air_friction
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= sign(velocity.x)*deacceleration*delta*factor
		if signal_velocity != velocity.x/abs(velocity.x):
			velocity.x = 0
	velocity.x = clamp(velocity.x, -speed, speed)
	return

func vertical_move(delta: float, factor: float = 1):
	self.velocity.y += gravity*delta*factor
	if self.velocity.y > falling_speed:
		self.velocity.y = falling_speed



func jump():
	$SFX/Jump.play()
	self.velocity.y = -jump_speed



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
	match projectile.get_state():
		"StandingState":
			$SFX/BulletPickup.play()
		"FuelChargeState":
			recharge_fuel()
		
	projectile.speed = 0
	self.has_bullet = true
	if self.get_state() == "BulletBoostingState":
		$BoostTimer.stop()
		_on_BoostTimer_timeout()
	projectile.destroy()



func recharge_fuel() -> void:
	$SFX/FuelPickup.play()
	can_boost = true
	for particle in $FuelParticles.get_children():
		particle.emitting = true



func _on_BoostTimer_timeout():
	if get_state() == "BulletBoostingState":
		for particle in $FuelParticles.get_children():
			particle.emitting = false



func drop() -> void:
	if control_handler.get_directional_input().y == 1 && $DropTimer.is_stopped() && is_on_floor() && is_on_platform():
		self.set_collision_mask_bit(1,false)
		$DropTimer.start()

func _on_DropTimer_timeout():
	self.set_collision_mask_bit(1,true)



func _on_SpikesSentinel_body_entered(body):
	if body.is_in_group("spikes"):
		change_state("DyingState")



