extends MenuHSlider

func _ready():
	$HSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('SFX')))

func _on_HSlider_value_changed(value):
	sound_control.change_sfx_volume_value(value)
