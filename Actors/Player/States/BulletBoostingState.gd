extends PlayerBaseState
class_name BulletBoostingState

var bullet: KinematicBody2D
var relative_position_to_bullet: Vector2
var boost_velocity: Vector2
var boost_speed: float
var boost_time: float
var boost_timer: float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
#	owner.get_node("SFX/SuperJump").play()
	owner.get_node("SFX/Boost").pitch_scale = rand_range(1.0, 1.3)
	owner.get_node("SFX/Boost").set_stream(owner.get_node("PlayerSprite").boost_sounds[randi()%3])
	owner.get_node("SFX/Boost").get_stream().set_loop(false)
	owner.get_node("SFX/Boost").play()
	owner.can_boost = false
	boost_time = 0
	boost_timer = 0
	bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
	relative_position_to_bullet = (bullet.position - owner.position)
	
	if relative_position_to_bullet.length()/owner.boost_time < owner.boost_speed:
		print("First BulletBoosting Case")
		boost_velocity = relative_position_to_bullet.normalized()*owner.boost_speed
		boost_time = relative_position_to_bullet.length()/owner.boost_speed
	elif relative_position_to_bullet.length()/owner.boost_time < 2*owner.boost_speed:
		print("Second BulletBoosting Case")
		boost_velocity = relative_position_to_bullet/owner.boost_time
		boost_time = owner.boost_time
	elif relative_position_to_bullet.length()/owner.boost_time >= 2*owner.boost_speed:
		print("Third BulletBoosting Case")
		boost_velocity = 2*owner.boost_speed*relative_position_to_bullet.normalized()
		boost_time = relative_position_to_bullet.length()/(2*owner.boost_speed)
		print(relative_position_to_bullet.length())
		print(2*owner.boost_speed)
	
	boosting_particles(true)
	print(boost_time)
	owner.velocity = boost_velocity
	boost_speed = boost_velocity.length()

func update(delta):
	animation_player.play("Airborne")
	boost_timer += delta
	
	if boost_input_pressed():
		return
	if bullet_boost_input_pressed():
		return
	
	if boost_timer >= boost_time or owner.has_bullet:
		owner.change_state("OnAirState")
	else:
		bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		owner.velocity = (bullet.position - owner.position).normalized()*boost_speed



func exit():
	boosting_particles(false)



