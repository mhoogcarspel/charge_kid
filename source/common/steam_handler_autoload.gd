extends Node

onready var steam_handler = SteamHandler.new()

var is_steam_api_initialized: bool

func _ready():
	print("Steam API initialization success: " + String(steam_handler.steam_api_init()))
	print("Steam API RequestCurrentStats: " + String(steam_handler.request_current_stats()))
	print("StemUser is on:" + String(steam_handler.is_steam_user_on()))
	print("StemUserStats is on:" + String(steam_handler.is_steam_user_stats_on()))
	AchievementsAndStatsObserver.connect("clear_achievement", self, "clear_achievement")
	AchievementsAndStatsObserver.connect("set_achievement", self, "set_achievement")
	AchievementsAndStatsObserver.connect("reset_all_stat", self, "reset_all_stats")
	AchievementsAndStatsObserver.connect("set_stat", self, "set_stat")
	AchievementsAndStatsObserver.connect("indicate_achievement_progress", self,"indicate_achievement_progress")
	AchievementsAndStatsObserver.connect("get_stat", self, "get_stat")
	AchievementsAndStatsObserver.connect("get_achievement", self, "get_achievement")
	
	
func clear_achievement(achievement_api_name: String) -> void:
	steam_handler.clear_steam_achievement(achievement_api_name)

func set_achievement(achievement_api_name:String) -> void:
	steam_handler.set_steam_achievement(achievement_api_name)

func reset_all_stats(achievements_too: bool) -> void:
	steam_handler.reset_all_steam_stats(achievements_too)

func set_stat(stat_api_name: String, value) -> void:
	if value is int:
		print("set_int_stat succes:" + String(steam_handler.set_steam_int_stat(stat_api_name, value)))
	elif value is float:
		print("set_flota_stat succes:" + String(steam_handler.set_steam_float_stat(stat_api_name, value)))
	print("store_stat success:" + String(steam_handler.store_stats()))

func indicate_achievement_progress(achievement_name_api: String, current_progress: int, max_progress: int) -> void:
	steam_handler.indicate_steam_achievement_progress(achievement_name_api, current_progress, max_progress)

func get_stat(stat_name: String, variable_name: String, emitter: Node) -> void:
	emitter.set(variable_name, steam_handler.get_int_stat(stat_name))

func get_achievement(achievement_name: String, variable_name: String, emitter: Node) -> void:
	emitter.set(variable_name, steam_handler.get_achievement(achievement_name))
