extends Control
class_name MenuOption

export(float) var switch_option_time

onready var main:Node = get_tree().get_nodes_in_group("main")[0]
onready var switch_option_timer: Timer

func _ready():
	switch_option_timer = get_node_or_null("Timer")
	if switch_option_timer == null:
		switch_option_timer = Timer.new()
		self.add_child(switch_option_timer)
	
	switch_option_timer.wait_time = switch_option_time
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")


func _process(_delta):
	main  = get_tree().get_nodes_in_group("main")[0]
	
	if has_focus():
		if switch_option_timer.is_stopped() and main.get_node("MenuNavigation/MenuNavTimer").is_stopped():
			if main.control_handler.get_directional_input().y == 1:
				check_and_grab_focus(focus_neighbour_bottom)
			elif main.control_handler.get_directional_input().y == -1:
				check_and_grab_focus(focus_neighbour_top)
			elif main.control_handler.get_directional_input().x == 1:
				check_and_grab_focus(focus_neighbour_right)
			elif main.control_handler.get_directional_input().x == -1:
				check_and_grab_focus(focus_neighbour_left)
		if main.control_handler.get_directional_input() == Vector2.ZERO and not switch_option_timer.is_stopped():
			switch_option_timer.stop()

func check_and_grab_focus(path :NodePath):
	var option : = get_node_or_null(path)
	if option != null:
		option.grab_focus()

func _on_focus_entered():
	if switch_option_timer.is_inside_tree():
		switch_option_timer.start(switch_option_time)

func _on_focus_exited():
	if main.get_node("MenuNavigation/MenuAcceptTimer").is_stopped():
		main.get_node("MenuNavigation/MenuNavigate").play()
