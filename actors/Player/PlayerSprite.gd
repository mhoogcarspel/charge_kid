extends Sprite



export (PackedScene) var step_particles
export (PackedScene) var land_particles

onready var player = get_parent()
onready var step: int = 0



func _ready():
	self.get_material().set_shader_param("activate", false)
	self.get_material().set_shader_param("erase", false)

func _physics_process(delta):
	get_material().set_shader_param("fuel", player.can_boost)
	$ProjectileParticles.emitting = player.has_bullet
	flip_sprite()
	if player.can_boost:
		for particle in player.get_node("FuelParticles").get_children():
			particle.emitting = true
	else:
		for particle in player.get_node("FuelParticles").get_children():
			particle.emitting = false
	
	if player.get_state() == "DyingState" and $Timer.is_stopped():
		self.position = position.rotated(deg2rad(180))
		var angle = randi()%90 - 45
		self.position = position.rotated(deg2rad(angle))
		$Timer.start()

func flip_sprite() -> void:
	if player.facing > 0 && !self.transform.x.x == 1:
		self.transform.x.x = 1
	elif player.facing < 0 && !self.transform.x.x == -1:
		self.transform.x.x = -1



func steps() -> void:
	if step == 0:
		player.get_node("SFX/Step").pitch_scale = 0.8
		player.get_node("SFX/Step").play()
		step = 1
	elif step == 1:
		player.get_node("SFX/Step").pitch_scale = 0.9
		player.get_node("SFX/Step").play()
		step = 0
	
	var particles = step_particles.instance()
	particles.transform.x.x = -player.facing
	particles.transform.y.y = -player.facing
	particles.position = player.position + Vector2(0, 8)
	player.get_parent().add_child(particles)

func land() -> void:
	player.get_node("SFX/Land").play()
	var particles = land_particles.instance()
	particles.transform.x.x = -player.facing
	particles.transform.y.y = -player.facing
	particles.position = player.position + Vector2(-4*player.facing, 8)
	player.get_parent().add_child(particles)



func shoot_particles() -> void:
	for particle in player.get_node("ShootParticles").get_children():
		particle.emitting = true



func kill() -> void:
	$ProjectileParticles.visible = false
	self.get_material().set_shader_param("activate", true)
	var angle = randi()%360 - 180
	self.position = Vector2(4,0).rotated(deg2rad(angle))
	$Timer2.start()

func _on_Timer2_timeout():
	self.get_material().set_shader_param("erase", true)



