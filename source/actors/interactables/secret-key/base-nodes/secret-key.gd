extends StaticBody2D

export (int) var key_number

export (PackedScene) var hit_particles
export (PackedScene) var white_transition
export (PackedScene) var black_transition

export (PackedScene) var secret_keys_scene
export (PackedScene) var end_scene
export (PackedScene) var speedrun_finish

onready var state: int = 0



func _ready():
	$AnimationPlayer.play("Anim0")
	$Sprite/EnergyRays.hide()



func start_phase_2():
	$Sprite/EnergyRays.position.y = -1
	$Sprite/EnergyRays/LeftRay.position.x = -4
	$Sprite/EnergyRays/RightRay.position.x = 4
	$Sprite/EnergyRays.show()
	
	for node in $Sprite/Phase2BottomParticles.get_children():
		node.emitting = true
	for node in $Sprite/Phase2TopParticles.get_children():
		node.emitting = true
		
	$Sprite/RippleSource.speed = -1
	$Sprite/RippleSource.radius = 64
	$Sprite/RippleSource.amplitude = 4
	$Sprite/RippleSource.pulses = 6

func start_phase_3():
	$Sprite/EnergyRays.position.y = 2
	
	for node in $Sprite/Phase2TopParticles.get_children():
		node.emitting = false
	for node in $Sprite/Phase3TopParticles.get_children():
		node.emitting = true
	
	$Sprite/RippleSource.speed = -2
	$Sprite/RippleSource.radius = 128
	$Sprite/RippleSource.amplitude = 6
	$Sprite/RippleSource.pulses = 6

func start_phase_4():
	$Sprite/EnergyRays.position.y = 0
	$Sprite/EnergyRays/LeftRay.position.x = -8
	$Sprite/EnergyRays/RightRay.position.x = 8
	
	for node in $Sprite/Phase4BottomParticles.get_children():
		node.emitting = true
	for node in $Sprite/Phase2BottomParticles.get_children():
		node.emitting = false
	
	$Sprite/RippleSource.speed = -4
	$Sprite/RippleSource.radius = 194
	$Sprite/RippleSource.amplitude = 12
	$Sprite/RippleSource.pulses = 6



func pause_player():
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.change_state("StatelessState")



func spawn_white_transition():
	var transition = white_transition.instance()
	transition.position = self.position
	get_parent().add_child(transition)



func spawn_black_transition():
	var transition = black_transition.instance()
	var camera = get_tree().get_nodes_in_group("camera")[0]
	transition.position = camera.get_camera_screen_center()
	get_parent().add_child(transition)



func go_to_next_level():
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var save_file = main.get_node("SaveFileHandler")
		
		if not save_file.has_all_secrets():
			save_file.progress["secrets"][key_number] = true
			save_file.save_progress()
			if save_file.has_all_secrets():
				main.change_scene(save_file.secret_levels[0])
				return
		
		var level = get_tree().get_nodes_in_group("level")[0].level
		var speedrun_mode = main.get_node("SpeedrunMode")
		if level < 17:
			if not speedrun_mode.is_active():
				main.change_scene(secret_keys_scene, 0, level)
			else:
				main.change_scene(save_file.levels[level])
		else:
			if speedrun_mode.is_active() and speedrun_mode.category == "times":
				main.change_scene(speedrun_finish)
			elif not speedrun_mode.is_active():
				main.change_scene(secret_keys_scene, 0, level)
			else:
				main.change_scene(save_file.secret_levels[0])



func shake_screen(intensity: float = 24, damping: float = 4):
	var camera = get_tree().get_nodes_in_group("camera")[0]
	camera.shake_screen(intensity, damping)



func hit(bullet: PlayerBullet):
	bullet.change_state("ReturnState")
	if state < 5:
		state += 1
		$AnimationPlayer.play("Anim" + String(state))
		
		var particles = hit_particles.instance()
		particles.position = bullet.position
		get_parent().add_child(particles)
		
		if state == 1:
			shake_screen()




