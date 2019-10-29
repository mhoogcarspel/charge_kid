extends KinematicBody2D
class_name Player

export(bool) var god_mode

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
onready var boost_speed: float = boost_distance/boost_time

export(float) var coyote_time
export(float) var bunny_time
export(float) var jump_height
export(float) var gravity_acceleration

var main
var control_handler

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
	"DyingState" : DyingState.new(self),
	"StatelessState" : StatelessState.new(self)
	}
onready var actual_state: String
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
	actual_state = stack[0]
	states[actual_state].update(delta)
	
	if get_state() != "DyingState" and get_state() != "StatelessState":
		velocity = move_and_slide(velocity, Vector2(0, -1))
		if is_on_floor():
			$CoyoteTimer.start(coyote_time)
			pre_checkpoint = position
		
		if Input.is_action_just_pressed("ui_reset"):
			change_state("DyingState")

func change_state(state: String):
	var previous_state = stack[0]
	
	match state:
		"IdleState":
			while(stack[0] != "IdleState"):
				pop_state()
		"MovingState":
			states[previous_state].exit()
		"ShootingState":
			states[previous_state].exit()
		"OnAirState":
			states[previous_state].exit()
		"JumpingState":
			if previous_state == "JumpingState" or previous_state == "OnAirState":
				pop_state()
			else:
				states[previous_state].exit()
		"BoostingState","BulletBoostingState":
			if previous_state == "JumpingState" or previous_state == "BoostingState" or previous_state == "BulletBoostingState":
				pop_state()
			else:
				states[previous_state].exit()
		"DyingState":
			while(not stack.empty()):
				pop_state()
		"StatelessState":
			states[previous_state].exit()
	
	stack.push_front(state)
	states[state].enter()

func pop_state():
	states[stack[0]].exit()
	self.stack.pop_front()

func get_state() -> String:
	return stack[0]

func horizontal_move(direction: Vector2, delta: float, factor: float = 1.0, dissipation: bool = true) -> void:
	if direction.x != 0:
		velocity += direction*delta*horizontal_acceleration*factor
	elif velocity.x != 0 && dissipation:
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= velocity.x/abs(velocity.x)*deacceleration_horizontal_velocity*delta*factor
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
	if actual_state == "BulletBoostingState":
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



