extends KinematicBody2D

export(float) var gravity_acceleration
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed
export(float) var number_of_jumps
export(float) var coyote_jump_timer
export(float) var jump_velocity

var velocity := Vector2()

onready var can_jump: bool = true

func _ready():
	can_jump = true

func _physics_process(delta):
	move(get_directional_inputs(), delta)
	jump()
	damping()
	velocity = move_and_slide(velocity, Vector2(0,-1))
	

func damping() -> void:
	velocity.x = clamp(velocity.x, -horizontal_max_speed, horizontal_max_speed)

func move(direction: Vector2, delta: float) -> void:
	if direction.x != 0:
		velocity.x += direction.x*horizontal_acceleration*delta
	else:
		velocity.x = 0
	
	velocity.y += gravity_acceleration*delta

func jump() -> void:
	if can_jump && Input.is_action_pressed("ui_jump") && number_of_jumps > 0:
		print("JUMP MAH FRIEND")
		velocity.y = -jump_velocity
		can_jump = false
		number_of_jumps -= 1

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	, 0 #Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	#directionals.normalized()
	return directionals

func _on_CoyoteTimer_timeout() -> void:
	can_jump = false
