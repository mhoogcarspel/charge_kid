extends MenuOption
class_name MenuHSlider

onready var slide_timer = Timer.new()

func _ready():
	self.add_child(slide_timer)
