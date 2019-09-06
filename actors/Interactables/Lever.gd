extends StaticBody2D

export(Array,NodePath) var nodes

onready var is_active:bool = false
onready var particles = preload("res://assets/Particles/ProjectileHit.tscn")

func _ready():
	if is_active:
		$Lever.frame = 4
	else:
		$Lever.frame = 0

func hit(bullet:PhysicsBody2D):
	add_child(particles.instance())
	$SFX.play()
	if is_active:
		$Lever/AnimationPlayer.play("Deactivate")
		is_active = false
	else:
		$Lever/AnimationPlayer.play("Activate")
		is_active = true
	for nodepath in nodes:
		toggle(get_node(nodepath))
	if bullet.get_state() == "StandardState":
		bullet.change_state("ReturnState")



func toggle(object:Node) -> void:
	if object.is_active():
		object.deactivate()
	else:
		object.activate()



func _on_PlayerHitbox_body_entered(body):
	if body.is_in_group("player"):
		if is_active:
			$Lever/AnimationPlayer.play("Deactivate")
			is_active = false
		else:
			$Lever/AnimationPlayer.play("Activate")
			is_active = true
		for nodepath in nodes:
			toggle(get_node(nodepath))



