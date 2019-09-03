extends PlayerBaseState
class_name BulletBoostingState

var bullet: KinematicBody2D
var relative_position_to_bullet: Vector2
var boost_velocity: Vector2
var boost_speed: float
var boost_time:float
var boost_timer:float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.get_node("SFX/SuperJump").play()
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
	if boost_timer >= boost_time || owner.has_bullet:
		print(boost_timer)
		if !owner.is_on_floor() :
			owner.horizontal_move(get_directional_inputs(), delta, 3)
			print("Gravity")
			owner.gravity(delta, 2)
			print(owner.velocity.y)
			boosting_particles(false)
			
			if shoot_input_pressed():
				return
			elif boost_input_pressed():
				return
			elif bullet_boost_input_pressed():
				return
		else:
			land_sound()
			boosting_particles(false)
			owner.pop_state()
	
	else:
		bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		owner.velocity = (bullet.position - owner.position).normalized()*boost_speed
		

func exit():
	boosting_particles(false)