extends KinematicBody2D

export(float) var gravity_acceleration
export(float) var max_fall_speed
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed

export(int) var number_of_jumps
export(float) var coyote_jump_timer
export(float) var jump_velocity
export(float) var jump_control

var velocity := Vector2()

onready var facing : float = 1
onready var is_moving: bool = false
onready var can_jump: bool = true

func _physics_process(delta):
	if self.is_on_floor() && number_of_jumps > 0 && !can_jump:
		print("JUMP AGAIN MAH FRIEND")
		can_jump = true
	
	move(get_directional_inputs(), delta)
	jump()
	damping()
	velocity = move_and_slide(velocity, Vector2(0,-1))
	


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
		can_jump = false
		number_of_jumps -= 1
		
	if Input.is_action_just_released("ui_jump") && velocity.y < 0:
		velocity.y *= jump_control

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	, 0 )
	#directionals.normalized()
	return directionals

func _on_CoyoteTimer_timeout() -> void:
	can_jump = false

func is_airborne() -> bool:
	return !self.is_on_floor()
