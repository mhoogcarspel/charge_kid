extends Node
class_name SoundControl

onready var mus = AudioServer.get_bus_index("MUS")
onready var LowPassFilter:AudioEffectFilter
export var max_freq = 22000
export var min_freq = 450

onready var player:KinematicBody2D


func _ready():
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
			$BGM.get_children()[i].volume_db = 0

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

