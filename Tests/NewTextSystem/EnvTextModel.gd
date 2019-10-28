extends LabelBaseModel

func _ready():
	self.set("custom_colors/font_color", Color(1,0.31,0.47,0))
	$Tween.interpolate_property(self, "custom_colors/font_color", Color(1,0.31,0.47,0), Color(1,0.31,0.47,1), 1,$Tween.TRANS_LINEAR, $Tween.EASE_IN)