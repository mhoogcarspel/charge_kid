extends KinematicBody2D

export(float) var gravity_acceleration
export(float) var horizontal_acceleration
export(float) var horizontal_max_speed

export(float) var number_of_jumps

onready var can_jump: bool = true

func _physics_process(delta):
	if self.is_on_floor() && number_of_jumps > 0:
		can_jump = true #Add coyote jump timer
		pass
	

func get_diretional_inputs() -> Vector2:
	var directionals = Vector2(
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	, Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"))
	
	directionals.normalized()
	return directionals