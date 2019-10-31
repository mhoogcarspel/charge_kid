extends AudioStreamPlayer

const music = [
	'music1',
	'music2'
]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.play()
	
	connect("finished", self, "play_music")
	play_music()

func play_music():
	
	var rand_music = randi() % music.size()
	var audiostream = load('res://Assets/Music/' + music[rand_music] + '.ogg')
	set_stream(audiostream)
	play()
	