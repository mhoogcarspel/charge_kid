extends Sprite

onready var player = get_parent()
onready var step: int = 0

func _physics_process(delta):
	$ProjectileParticles.emitting = player.has_bullet
	flip_sprite(player.facing)

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
