extends AudioStreamPlayer

onready var mus = AudioServer.get_bus_index("MUS")
onready var  LowPassFilter:AudioEffectFilter
export var max_freq = 22000
export var min_freq = 200

onready var player = get_tree().get_nodes_in_group("player")

const music = [
	'music1',
	'music2'
]

func _ready():
	$Background.play()
	connect("finished", self, "play_music")
	play_music()
	_on_Music_finished()


func cut_freq():
	LowPassFilter = AudioServer.get_bus_effect(mus, 0)
	
	if player.get_state() == "DyingState":
		$FadeInOut.interpolate_property(LowPassFilter, "cutoff_hz", max_freq, min_freq, 2, 
											Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeInOut.start()
		print(LowPassFilter.get_cutoff())
	else:
		$FadeInOut.reset_all()
		$FadeInOut.interpolate_property(LowPassFilter, "cutoff_hz", min_freq, max_freq.max_value, 2, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeInOut.start()

func play_music():
	randomize()
	var rand_music = randi() % music.size()
	var audiostream = load('res://Assets/Music/' + music[rand_music] + '.ogg')
	audiostream.set_loop(false)
	$Music.set_stream(audiostream)
	$Music.set_volume_db(rand_range(0.2, 0.6))
	print($Music.get_volume_db())
	$Music.play()
#	
	

#func _on_Timer_timeout():
#	play_music()

func _on_Music_finished():
	play_music()

