extends MenuHSlider

func _ready():
	$HSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('MUS')))

func _on_HSlider_value_changed(value):
	sound_control.change_bgm_volume_value(value)
