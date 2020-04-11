extends Control


onready var main: Node
onready var pause_menu: bool

onready var windowed_button = $CenterContainer/Margin/Margin/Menu/Options/Windowed/ButtonModel
onready var windowed_label = $CenterContainer/Margin/Margin/Menu/Options/Windowed/LabelBaseModel2
onready var windowed_size_label = $CenterContainer/Margin/Margin/Menu/Options/Windowed/LabelBaseModel
onready var fullscreen_button = $CenterContainer/Margin/Margin/Menu/Options/FullScreen/ButtonModel
onready var fullscreen_label = $CenterContainer/Margin/Margin/Menu/Options/FullScreen/LabelBaseModel
onready var return_button = $CenterContainer/Margin/Margin/Menu/Return

# These screen sizes are 16:9 aspect ratio, the game's aspect ratio.
onready var screen_sizes = [Vector2(1024,576),
							Vector2(1152,648),
							Vector2(1280,720),
							Vector2(1366,768),
							Vector2(1600,900),
							Vector2(1920,1080), # Full HD
							Vector2(2560,1440), # 2k
							Vector2(3840,2160), # QHD
							Vector2(7680,4320)] # 8k

onready var window_size: Vector2 = Vector2(1024,576)



func _ready():
	get_tree().paused = true
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
	refocus()

func _process(_delta):
	window_size = OS.window_size
	if screen_sizes.has(window_size):
		windowed_size_label.text = window_size.x as String + "x" + window_size.y as String
	else:
		windowed_size_label.text = "Custom"
	
	### Recolor windowed and fullscreen buttons due to focus ##########################
	if windowed_button.has_focus():
		windowed_label.set("custom_colors/font_color", Color("#ff4f78"))
		windowed_size_label.set("custom_colors/font_color", Color("#ff4f78"))
	else:
		windowed_label.set("custom_colors/font_color", Color("#f4f4e4"))
		windowed_size_label.set("custom_colors/font_color", Color("#f4f4e4"))
	if fullscreen_button.has_focus():
		fullscreen_label.set("custom_colors/font_color", Color("#ff4f78"))
	else:
		fullscreen_label.set("custom_colors/font_color", Color("#f4f4e4"))
	###################################################################################



func _on_Windowed_pressed():
	OS.window_fullscreen = false
	if screen_sizes.has(window_size):
		var pos = screen_sizes.find(window_size)
		var next_size = screen_sizes[pos + 1]
		if next_size.x <= OS.get_screen_size().x and next_size.y <= OS.get_screen_size().y:
			OS.window_size = next_size
		else:
			OS.window_size = screen_sizes[0]
	else:
		OS.window_size = screen_sizes[0]
	OS.center_window()



func _on_FullScreen_pressed():
	OS.window_fullscreen = true



func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().self_show()
		get_parent().refocus()
		self.queue_free()



func refocus() -> void:
	windowed_button.grab_focus()

func self_hide() -> void:
	$CenterContainer.hide()

func self_show() -> void:
	$CenterContainer.show()


