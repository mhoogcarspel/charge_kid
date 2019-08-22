extends Sprite

export (float) var time
export(Array,NodePath) var nodes



func activate() -> void:
	if not is_active():
		$Timer.start(time/3)
		$ActivateSFX.pitch_scale = 0.8
		$ActivateSFX.play()
		frame = 3
		for nodepath in nodes:
			get_node(nodepath).activate()
	else:
		$Timer.stop()
		$ActivateSFX.pitch_scale = 1.0
		$ActivateSFX.play()
		frame = 0
		for nodepath in nodes:
			get_node(nodepath).deactivate()

func _on_Timer_timeout():
	match frame:
		3:
			frame = 2
			$Timer.start(time/3)
			$TickSFX.play()
		2:
			frame = 1
			$Timer.start(time/3)
			$TickSFX.play()
		1:
			$Timer.stop()
			$ActivateSFX.pitch_scale = 1.0
			$ActivateSFX.play()
			frame = 0
			for nodepath in nodes:
				get_node(nodepath).deactivate()



func deactivate() -> void:
	$Timer.stop()
	$ActivateSFX.pitch_scale = 1.0
	$ActivateSFX.play()
	frame = 0
	for nodepath in nodes:
		get_node(nodepath).deactivate()



func is_active() -> bool:
	return not $Timer.is_stopped()




