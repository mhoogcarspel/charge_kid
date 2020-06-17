extends Node

signal set_achievement(achievement_api_name)
signal clear_achievement(achievement_api_name)

func set_achievement(achievement_name: String) -> void:
	emit_signal("set_achievement", achievement_name)

func clear_achievement(achievement_name: String) -> void:
	emit_signal("clear_achievement", achievement_name)
