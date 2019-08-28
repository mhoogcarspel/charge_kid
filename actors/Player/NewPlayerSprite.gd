extends Sprite

onready var player = get_parent()

func _physics_process(delta):
	flip_sprite(player.facing)

func flip_sprite(facing: float) -> void:
	if facing > 0 && !self.transform.x.x == 1:
		self.transform.x.x = 1
	elif facing < 0 && !self.transform.x.x == -1:
		self.transform.x.x = -1