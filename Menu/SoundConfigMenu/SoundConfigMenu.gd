extends Control

export(NodePath) var options_path

func _ready():
		$CenterContainer/Options.get_children()[0].grab_focus()