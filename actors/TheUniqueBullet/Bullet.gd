extends KinematicBody2D

export(String, "StandartState", "StandingState", "ReturnState", "FuelChargeState", "HoldState" ) var initial_state
export(float) var velocity
export(float) var velocity_fuel
export(float) var range_distance
export(float) var gravity_accel

onready var direction: Vector2
onready var linear_velocity: Vector2
onready var player = get_tree().get_nodes_in_group("player")[0]

onready var states: Dictionary = {
	"StandardState": StandardState.new(self),
	"StandingState": StandingState.new(self),
	"ReturnState" : ReturnState.new(self, player),
	"FuelChargeState" : FuelChargeState.new(self, player),
	"HoldState" : HoldState.new(self)
	}

onready var stack: Array = []

func _ready():
	stack.push_front(initial_state)
	states[initial_state].enter()

func _process(delta):
	states[stack[0]].update(delta)
	linear_velocity = move_and_slide(linear_velocity)

func change_state(state: String) -> void:
	var previous_state = states[stack[0]]
	match stack[0]:
		"StandardState":
			stack.pop_front()
			stack.push_front(state)
		"ReturnState":
			if !state == "HoldState":
				stack.pop_front()
			stack.push_front(state)
		"HoldState":
			stack.pop_front()
			if !state == "ReturnState":
				stack.push_front(state)
	previous_state.exit()
	states[state].enter()

func destroy() -> void:
	states[stack[0]].exit()
	$ProjectileParticles.emitting = false
	$FuelChargeParticles.emitting = false
	$FuelChargeParticles/CPUParticles2D.emitting = false
	linear_velocity = Vector2()
	var death_timer = Timer.new()
	get_parent().add_child(death_timer)
	death_timer.start(0.2)
	yield(death_timer, "timeout")
	self.queue_free()

func _on_HitBox_body_entered(body):
	if not body.is_in_group("bullet"):
		body.hit(self)
