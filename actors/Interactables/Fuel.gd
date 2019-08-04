tool
extends StaticBody2D



export (String, "Full", "Empty") var state setget change_state
export (float) var refill_time

onready var particles = preload("res://assets/Particles/ProjectileHit.tscn")
var has_fuel: bool



func change_state(new_state: String) -> void:
	if Engine.editor_hint:
		if new_state == "Full":
			has_fuel = true
			$FuelTank.frame = 6
			state = new_state
		elif new_state == "Empty":
			has_fuel = false
			$FuelTank.frame = 0
			state = new_state



func is_full() -> bool:
	return has_fuel

func is_empty() -> bool:
	return not has_fuel



func fill() -> void:
	if is_empty():
		$FuelTank/AnimationPlayer.play("Filling")
		has_fuel = true

func empty() -> void:
	if is_full():
		$FuelTank/AnimationPlayer.play("Emptying")
		has_fuel = false
		if refill_time > 0:
			$RefillTime.start(refill_time)

func hit(bullet: PhysicsBody2D):
	if is_full():
		bullet.charge_bullet()
		$FuelTank/AnimationPlayer.play("Hit")
		add_child(particles.instance())
		has_fuel = false
		if refill_time > 0:
			$RefillTime.start(refill_time)



func activate() -> void:
	fill()

func deactivate() -> void:
	empty()



func _ready() -> void:
	if not Engine.editor_hint:
		if state == "Full":
			has_fuel = true
			$FuelTank.frame = 6
		elif state == "Empty":
			has_fuel = false
			$FuelTank.frame = 0

func _on_RefillTime_timeout():
	fill()

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player") and is_full():
		body.recharge_fuel()
		empty()






