extends PlayerBaseState
class_name DyingState

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.velocity = Vector2.ZERO
	owner.get_node("SFX/Death").play()
	owner.get_node("PlayerSprite").kill()
	owner.get_node("AnimationPlayer").play("Airborne")
	for particle in owner.get_node("DeathParticles").get_children():
		particle.emitting = true
	owner.can_boost = false
	
	var shader = owner.get_node("PlayerSprite").ripples_shader.instance()
	shader.position = owner.position
	shader.speed = 600
	shader.wave_length = 160
	shader.length_increase = 0
	shader.initial_amplitude = 30
	shader.amp_linear_decrease = false
	shader.amp_hyp_decrease = false
	shader.amplitude_decrease = 0
	shader.pulses = 4
	owner.get_parent().add_child(shader)
	
	var camera = owner.get_tree().get_nodes_in_group("camera")[0]
	camera.player_just_died()
	camera.shake_screen(24)
	
	var timer = Timer.new()
	owner.add_child(timer)
	timer.start(1)
	yield(timer, "timeout")
	owner.queue_free()
	
	if owner.get_tree().get_nodes_in_group("main").size() > 0:
		var main = owner.get_tree().get_nodes_in_group("main")[0]
		var next_player = main.player_scene.instance()
		next_player.position = owner.checkpoint
		next_player.checkpoint = owner.checkpoint
		
		# Deal with onscreen bullets.
		if owner.get_tree().get_nodes_in_group("bullet").size() > 0:
			var bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
			if bullet.get_state() == "StandingState":
				next_player.has_bullet = false
			else:
				bullet.queue_free()
		
		owner.get_parent().add_child(next_player)
	else:
		owner.get_tree().reload_current_scene()
