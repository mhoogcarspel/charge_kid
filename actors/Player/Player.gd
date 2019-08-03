extends KinematicBody2D

export(PackedScene) var bullet

export(bool) var god_mode

export(float) var gravity_acceleration
export(float) var max_fall_speed
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed

export(int) var number_of_jumps
export(float) var jump_velocity
export(float) var jump_control

export(float) var shoot_offset

var velocity := Vector2()

onready var facing : float = 1

onready var can_shoot: bool = true
onready var can_jump: bool = true

onready var is_shooting: bool = false
onready var is_jumping: bool = false
onready var is_moving: bool = false

func _ready():
	if god_mode:
		number_of_jumps = 9999999

func _physics_process(delta):
	if number_of_jumps > 0:
		can_jump = true
	
	shoot()
	if !is_shooting:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		move(get_directional_inputs(), delta)
		jump()
		damping()
	


func damping() -> void:
	velocity.x = clamp(velocity.x, -horizontal_max_speed, horizontal_max_speed)
	velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)

func move(direction: Vector2, delta: float) -> void:
	if direction.x != 0:
		velocity.x += direction.x*horizontal_acceleration*delta
		facing = direction.x/abs(direction.x)
		is_moving = true
	
	else:
		velocity.x = 0
		is_moving = false
	
	velocity.y += gravity_acceleration*delta

func jump() -> void:
	if can_jump && Input.is_action_just_pressed("ui_jump") && number_of_jumps > 0:
		print("JUMP MAH FRIEND")
		velocity.y = -jump_velocity
		
		if !god_mode:
			can_jump = false
		
		is_jumping = true
		number_of_jumps -= 1
		
	if Input.is_action_just_released("ui_jump") && velocity.y < 0:
		velocity.y *= jump_control

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	, 0 )
	#directionals.normalized()
	return directionals


func is_airborne() -> bool:
	return !self.is_on_floor()

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

func hit(projectile: Area2D) -> void:
	self.can_shoot = true
	projectile.queue_free()