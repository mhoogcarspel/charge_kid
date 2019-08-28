extends KinematicBody2D

export(bool) var has_bullet

export(float) var horizontal_acceleration
export(float) var max_horizontal_velocity
export(float) var deacceleration_horizontal_velocity

export(float) var coyote_time
export(float) var jump_height
export(float) var gravity_acceleration
export(float) var max_falling_velocity

onready var jump_velocity = sqrt(2*jump_height*gravity_acceleration)
onready var velocity: Vector2

onready var states: Dictionary = {
	"IdleState" : IdleState.new(self),
	"MovingState" : MovingState.new(self),
	"OnAirState" : OnAirState.new(self),
	"JumpingState" : JumpingState.new(self)
	}
onready var actual_state: String
onready var stack: Array = []

onready var can_shoot:bool
onready var can_boost:bool

func _ready():
	can_shoot = has_bullet
	stack.push_front("IdleState")

func _physics_process(delta):
	actual_state = stack[0]
	states[actual_state].update(delta)
	
	$StateMachineDebugger.text = actual_state
	velocity = move_and_slide(velocity, Vector2(0, -1))

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
			stack.push_front(state)
	states[previous_state].exit()
	states[state].enter()

func pop_state():
	self.stack.pop_front()

func horizontal_move(direction: Vector2, delta: float, factor: float = 1.0) -> void:
	if direction.x != 0:
		velocity += direction*delta*horizontal_acceleration*factor
		velocity.x = clamp(velocity.x, -max_horizontal_velocity, max_horizontal_velocity)
	elif velocity.x != 0:
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= velocity.x/abs(velocity.x) * deacceleration_horizontal_velocity * delta
		if signal_velocity != velocity.x/abs(velocity.x):
			velocity.x = 0
	return

func gravity(delta: float):
	self.velocity.y += gravity_acceleration*delta
	velocity.y = clamp(velocity.y, 0, max_falling_velocity)