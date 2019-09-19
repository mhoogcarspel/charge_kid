tool
extends TileMap



export (bool) var active setget change_state

func change_state(new_value) -> void:
	active = new_value
	if active:
		get_material().set_shader_param("active", true)
	else:
		get_material().set_shader_param("active", false)



func activate() -> void:
	active = true
	get_material().set_shader_param("active", true)
	var timer = Timer.new()
	self.add_child(timer)
	
	self.position.x += 2
	timer.start(0.1)
	yield(timer, "timeout")
	
	self.position.x -= 3
	timer.start(0.1)
	yield(timer, "timeout")
	
	self.position.x += 1
	timer.queue_free()

func deactivate() -> void:
	active = false
	get_material().set_shader_param("active", false)



func is_active() -> bool:
	return active




