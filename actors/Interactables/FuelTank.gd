tool
extends Sprite



export (String, "Full", "Empty") var state setget change_state
export (float) var refill_time

onready var particles = preload("res://assets/Particles/ProjectileHit.tscn")
var has_fuel: bool



func change_state(new_state: String) -> void:
	if new_state == "Full":
		has_fuel = true
		frame = 6
		state = new_state
	elif new_state == "Empty":
		has_fuel = false
		frame = 0
		state = new_state

func _ready():
	if not Engine.editor_hint:
		if state == "Full":
			has_fuel = true
			frame = 6
		elif state == "Empty":
			has_fuel = false
			frame = 0



func is_full() -> bool:
	return has_fuel

func is_empty() -> bool:
	return not has_fuel

func is_active() -> bool:
	return has_fuel



func fill() -> void:
	if is_empty():
		$AnimationPlayer.play("Fill")
		yield($AnimationPlayer, "animation_finished")
		has_fuel = true
		for body in $PlayerHitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				_on_PlayerHitbox_body_entered(body)

func empty() -> void:
	if is_full():
		$AnimationPlayer.play("Empty")
		has_fuel = false
		if refill_time > 0:
			$RefillTime.start(refill_time)

func hit(bullet: PhysicsBody2D):
	if is_full():
		$SFX.play()
		bullet.charge_bullet()
		$AnimationPlayer.play("Hit")
		add_child(particles.instance())
		has_fuel = false
		if refill_time > 0:
			$RefillTime.start(refill_time)

func _on_RefillTime_timeout():
	fill()



func activate() -> void:
	fill()

func deactivate() -> void:
	empty()



func _on_PlayerHitbox_body_entered(body):
	if body.is_in_group("player") and is_full():
		body.recharge_fuel()
		empty()



