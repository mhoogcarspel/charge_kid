extends Area2D



func _process(delta):
	if $Timer.is_stopped() and $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.text = "Try using the momentum \n of a bullet boost!"
				$Tween.interpolate_property($Text, "percent_visible", 0, 1, 0.5,
											Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()

func _ready():
	visible = true


