extends KinematicBody2D

export(float) var gravity_acceleration
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed
export(float) var number_of_jumps
export(float) var coyote_jump_timer
export(float) var jump_velocity

onready var can_jump: bool = true

var move: float
var velocity := Vector2()

func _physics_process(delta):
	
	if self.is_on_floor() && number_of_jumps > 0:
		can_jump = true #Add coyote jump timer
	if !self.is_on_floor():
		$CoyoteTimer.start()
	
	move(get_directional_inputs(), delta)
	jump()
	


func move(direction: Vector2, delta: float) -> void:
	if direction.x != 0:
		velocity.x += direction.x*horizontal_acceleration*delta

func jump() -> void:
	if can_jump:
		velocity.y -= jump_velocity

func get_directional_inputs() -> Vector2:
	var directionals = Vector2(
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	, Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"))
	
	directionals.normalized()
	return directionals

func _on_CoyoteTimer_timeout() -> void:
	can_jump = false
