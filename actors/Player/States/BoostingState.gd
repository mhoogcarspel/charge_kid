extends PlayerBaseState
class_name BoostingState

func enter():
	owner.velocity = Vector2(0, -owner.boost_speed)
	owner.get_node("SFX/SuperJump").play()
	owner.get_node("FeetParticles").emitting = false
	owner.get_node("$FeetParticles2").emitting = false
	owner.get_node("$FeetParticles3").emitting = false
	owner.get_node("$BoostParticles1").emitting = true
	owner.get_node("$BoostParticles2").emitting = true
	owner.get_node("$BoostParticles3").emitting = true
	owner.get_node("$BoostParticles4").emitting = true
