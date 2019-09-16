extends Sprite

onready var player = get_parent()
onready var step: int = 0



func _ready():
	self.get_material().set_shader_param("activate", false)
	self.get_material().set_shader_param("erase", false)

func _physics_process(delta):
	$ProjectileParticles.emitting = player.has_bullet
	flip_sprite(player.facing)
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

func flip_sprite(facing: float) -> void:
	if facing > 0 && !self.transform.x.x == 1:
		self.transform.x.x = 1
	elif facing < 0 && !self.transform.x.x == -1:
		self.transform.x.x = -1

func step_sound() -> void:
	if step == 0:
		owner.get_node("SFX/Step").pitch_scale = 0.8
		owner.get_node("SFX/Step").play()
		step = 1
	elif step == 1:
		owner.get_node("SFX/Step").pitch_scale = 0.9
		owner.get_node("SFX/Step").play()
		step = 0

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



