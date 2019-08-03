extends Sprite


func _ready():
	deactivate()

func activate() -> void:
	var timer: Timer = Timer.new()
	self.add_child(timer)
	
	self.visible = true
	self.get_material().set_shader_param("color", Color(1,1,1,1))
	timer.start(0.2)
	yield(timer, "timeout")
	self.get_material().set_shader_param("color", Color(0,0,0,1))
	
	timer.queue_free()


func deactivate() -> void:
	self.visible = false
