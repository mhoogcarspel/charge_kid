extends Node

onready var save_file: Node = get_parent().get_node("SaveFileHandler")
onready var screen_timer: Label = get_parent().get_node("HudContainer/Box/Box/SpeedrunTimer")
onready var active: bool = false
onready var seconds: float = 0.0
onready var minutes: int = 0



func ready() -> void:
	seconds = 0
	minutes = 0
	screen_timer.text = "0:00.00"
	screen_timer.visible = true


func go() -> void:
	active = true
	owner.get_node("BackgroundAndMusicHandler").music_pitch_shift()
	$Start.play()


func _physics_process(delta):
	if active:
		seconds += delta
		
		if seconds >= 60:
			seconds -= 60
			minutes += 1
		
		var screen_seconds = stepify(seconds, 0.01)
		if screen_seconds < 10:
			screen_seconds = "0" + String(screen_seconds)
		else:
			screen_seconds = String(screen_seconds)
		while screen_seconds.length() < 5:
			if screen_seconds.length() == 2:
				screen_seconds += "."
			else:
				screen_seconds += "0"
		
		screen_timer.text = String(minutes) + ":" + screen_seconds



func time() -> Dictionary:
	active = false
	owner.get_node("BackgroundAndMusicHandler").music_pitch_normal()
	screen_timer.visible = false
	return { "string": screen_timer.text , "float": minutes*60 + seconds}



func is_active() -> bool:
	return active


