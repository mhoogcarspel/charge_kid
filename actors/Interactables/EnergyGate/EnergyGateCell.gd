tool
extends Node2D



export (bool) var active setget set_active
export (PackedScene) var hit_particles

func set_active(new_value):
	if new_value == true:
		$Sprite.visible = true
		$Hitbox/CollisionShape2D.disabled = false
		$Sparks.emitting = true
	else:
		$Sprite.visible = false
		$Hitbox/CollisionShape2D.disabled = true
		$Sparks.emitting = false
	active = new_value



func on_body_entered(body):
	if not Engine.editor_hint and body.is_in_group("player"):
		if body.get_state() == "BoostingState" and body.get_state() == "BulletBoostingState":
			var level = get_tree().get_nodes_in_group("level")[0]
			level.add_child(hit_particles.instance())
		else:
			body.change_state("DyingState")

func on_area_entered(area):
	if not Engine.editor_hint and area.get_parent().is_in_group("bullet"):
		var level = get_tree().get_nodes_in_group("level")[0]
		level.add_child(hit_particles.instance())



func activate():
	self.active = true

func deactivate():
	self.active = false

func is_active():
	return active



