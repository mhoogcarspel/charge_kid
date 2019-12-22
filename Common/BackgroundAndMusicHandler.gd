extends Node
class_name SoundControl

export(float) var bgm_starting_volume
export(float) var sfx_starting_volume
onready var bgm_volume_value: float
onready var sfx_volume_value: float

onready var main = get_parent()
onready var mus = AudioServer.get_bus_index("MUS")
onready var LowPassFilter:AudioEffectFilter
export var max_freq = 22000
export var min_freq = 450

onready var player:KinematicBody2D


func _ready():
	load_sound_config()
	pass
#	play_music()

func _physics_process(delta):
	if !get_tree().get_nodes_in_group("player").empty():
		player = get_tree().get_nodes_in_group("player")[0]

func zero_all_bgm() -> void:
	for bgm in $BGM.get_children():
		bgm.volume_db = -80

func set_volume_bgm(list:Array):
	for i in range(list.size()):
		if list[i]:
			$BGM.get_children()[i].volume_db = linear2db(bgm_volume_value)

func death_effect():
	LowPassFilter = AudioServer.get_bus_effect(mus, 0)
	
	$FadeInOut.interpolate_property(LowPassFilter, "cutoff_hz", max_freq, min_freq, 0.2, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
	$FadeInOut.start()
	print(LowPassFilter.get_cutoff())

func respawn_effect():
	$FadeInOut.reset_all()
	$FadeInOut.interpolate_property(LowPassFilter, "cutoff_hz", min_freq, max_freq, 3, 
									Tween.TRANS_EXPO, Tween.EASE_OUT)
	$FadeInOut.start()

#func play_music():
#	randomize()
#	var rand_music = randi() % music.size()
#	var audiostream = load('res://Assets/Music/' + music[rand_music] + '.ogg')
#	audiostream.set_loop(false)
#	$Music.set_stream(audiostream)
#	$Music.set_volume_db(rand_range(0.2, 0.6))
#	print($Music.get_volume_db())
#	$Music.play()
#	
	

#func _on_Timer_timeout():
#	play_music()

#func _on_Music_finished():
#	play_music()

#### Functions Related to Volume control ######

func load_sound_config():
	var file = File.new()
	if file.file_exists(main.sound_config + ".conf"):
		file.open(main.sound_config + ".conf", File.READ)
		var sound_cfg:Dictionary = parse_json(file.get_line())
		for bus in sound_cfg.keys():
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(float(sound_cfg[bus])))
		file.close()
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUS"), linear2db(bgm_starting_volume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_starting_volume))
	bgm_volume_value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUS")))
	sfx_volume_value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	

func change_bgm_volume_value(linear_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUS"), linear2db(linear_value))

func change_sfx_volume_value(linear_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(linear_value))