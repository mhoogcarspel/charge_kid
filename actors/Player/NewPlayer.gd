extends KinematicBody2D

export(float) var horizontal_acceleration
export(float) var max_horizontal_velocity
export(float) var deacceleration_horizontal_velocity

export(float) var gravity_acceleration
export(float) var max_falling_velocity

onready var velocity: Vector2
onready var states: Dictionary = {
	"IdleState" : IdleState.new(self),
	"MovingState" : MovingState.new(self)
	}
onready var actual_state: String
onready var stack: Array = []

func _ready():
	stack.push_front("IdleState")

func _physics_process(delta):
	actual_state = stack[0]
	states[actual_state].update(delta)
	
	$StateMachineDebugger.text = actual_state
	velocity = move_and_slide(velocity, Vector2(0, -1))

func change_state(state: String):
	match state:
		"IdleState":
			while(stack[0] != "IdleState"):
				stack.pop_front()
		"MovingState":
			stack.push_front(state)

func horizontal_move(direction: Vector2, delta: float, factor: float = 1.0) -> void:
	if direction.x != 0:
		velocity += direction*delta*horizontal_acceleration*factor
		velocity.x = clamp(velocity.x, -max_horizontal_velocity, max_horizontal_velocity)
	elif velocity.x != 0:
		print("xoxo")
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= velocity.x/abs(velocity.x) * deacceleration_horizontal_velocity * delta
		if signal_velocity != velocity.x/abs(velocity.x):
			velocity.x = 0
	return

func gravity(delta: float):
	self.velocity.y += gravity_acceleration*delta
	velocity.y = clamp(velocity.y, 0, max_falling_velocity)