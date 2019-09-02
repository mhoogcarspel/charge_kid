extends PlayerBaseState
class_name BulletBoostingState

var bullet: KinematicBody2D
var relative_position_to_bullet: Vector2
var boost_velocity: Vector2
var boost_time:float
var boost_timer:float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.get_node("SFX/SuperJump").play()
	owner.can_boost = false
	boost_time = 0
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

func update(delta):
	animation_player.play("Airborne")
	boost_timer += delta
	if !owner.is_on_floor():
		if !(boost_timer < boost_time):
			owner.horizontal_move(get_directional_inputs(), delta, 3)
			owner.gravity(delta, 2)
			boosting_particles(false)
			if Input.is_action_just_pressed("ui_boost") && owner.can_boost:
				if is_holding_bullet():
					owner.change_state("BulletBoostingState")
					return
				else:
					owner.change_state("BoostingState")
					return
	else:
		land_sound()
		boosting_particles(false)
		owner.pop_state()
	
	if Input.is_action_just_pressed("ui_shoot") && owner.has_bullet:
		owner.change_state("ShootingState")
		return

func exit():
	boosting_particles(false)
	boost_timer = 0