extends StaticBody2D



export (PackedScene) var particle_effects
export (bool) var active

onready var animation_player = $AnimationPlayer


func _ready():
	if active:
		animation_player.play("Ready")

func _physics_process(delta):
	if not active:
		animation_player.play("Inactive")



func activate() -> void:
	if not active:
		active = true
		animation_player.play("Hit")

func deactivate() -> void:
	active = false

func is_active() -> bool:
	return active



func hit(bullet: PlayerBullet) -> void:
	if animation_player.current_animation == "Ready":
		animation_player.play("Hit")
		
		if not get_tree().get_nodes_in_group("player").empty():
			var player = get_tree().get_nodes_in_group("player")[0] as Player
			player.change_state("StatelessState")
			bullet.change_state("StoppedState")
			player.animation_player.play("TeleportIn")
			bullet.animation_player.play("TeleportIn")
			
			yield(player.animation_player, "animation_finished")
			swap_positions(bullet, player)
			player.shake_screen(16)
			player.animation_player.play("TeleportOut")
			bullet.animation_player.play("TeleportOut")
			
			yield(player.animation_player, "animation_finished")
			player.change_state("IdleState")
			bullet.change_state("HoldState")

func swap_positions(bullet: PlayerBullet, player: Player) -> void:
	var dummy = player.position
	bullet.disable_enable_hitbox(false)
	player.position = bullet.position
	bullet.position = dummy



func on_animation_finished(animation):
	match animation:
		"Hit":
			animation_player.play("Recharging")
		"Recharging":
			animation_player.play("Ready")

func spawn_particles() -> void:
	var particles = particle_effects.instance()
	particles.position = self.position
	get_parent().add_child(particles)




