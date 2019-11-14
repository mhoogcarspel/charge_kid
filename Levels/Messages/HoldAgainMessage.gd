extends Area2D



func _process(delta):
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.text = "Try letting go of the \n bullet and holding again!"
				$Tween.interpolate_property($Text, "percent_visible", 0, 1, 0.5,
											Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()

func _ready():
	visible = true


