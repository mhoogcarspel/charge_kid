extends Sprite

onready var is_active:bool = true

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
	is_active = true
	
	timer.queue_free()


func deactivate() -> void:
	is_active = false
	self.visible = false
