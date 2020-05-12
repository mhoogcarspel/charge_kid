extends Label

func _ready():
	self.set("modulate", Color(1,1,1,0))
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
