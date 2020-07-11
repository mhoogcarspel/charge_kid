#include "steam_handler.h"

void SteamHandler::_bind_methods() {
   ClassDB::bind_method(D_METHOD("is_steam_running"), &SteamHandler::is_steam_running);
   ClassDB::bind_method(D_METHOD("steam_api_init"), &SteamHandler::steam_api_init);
   ClassDB::bind_method(D_METHOD("set_steam_achievement", "achievement"), &SteamHandler::set_steam_achievement);
   ClassDB::bind_method(D_METHOD("is_steam_user_stats_on"), &SteamHandler::is_steam_user_stats_on);
   ClassDB::bind_method(D_METHOD("is_steam_user_on"), &SteamHandler::is_steam_user_on);
   ClassDB::bind_method(D_METHOD("clear_steam_achievement", "achievement"), &SteamHandler::clear_steam_achievement);
   ClassDB::bind_method(D_METHOD("set_steam_int_stat", "stat", "value"), &SteamHandler::set_steam_int_stat);
   ClassDB::bind_method(D_METHOD("set_steam_float_stat", "stat", "value"), &SteamHandler::set_steam_float_stat);
   ClassDB::bind_method(D_METHOD("indicate_steam_achievement_progress", "stat", "current_progress", "max_progress"), &SteamHandler::indicate_steam_achievement_progress);
   ClassDB::bind_method(D_METHOD("reset_all_steam_stats", "achievements_too"), &SteamHandler::reset_all_steam_stats);
   ClassDB::bind_method(D_METHOD("get_int_stat", "stat"), &SteamHandler::get_int_stat);
   ClassDB::bind_method(D_METHOD("request_current_stats"), &SteamHandler::request_current_stats);
   ClassDB::bind_method(D_METHOD("get_achievement", "achievement"), &SteamHandler::get_achievement);
   ClassDB::bind_method(D_METHOD("store_stats"), &SteamHandler::store_stats);


}

SteamHandler::SteamHandler(){
}

SteamHandler::~SteamHandler(){
}

void SteamHandler::_init(){
}

bool SteamHandler::is_steam_running(){
    return SteamAPI_IsSteamRunning();
}
bool SteamHandler::steam_api_init(){
    return SteamAPI_Init();
}

bool SteamHandler::is_steam_user_stats_on(){
	return !(SteamUserStats() == NULL);
}

bool SteamHandler::is_steam_user_on(){
	return !(SteamUser() == NULL);
}

bool SteamHandler::set_steam_achievement(String achievement){
	if (is_steam_user_stats_on() && is_steam_user_on()){
		SteamUserStats()->SetAchievement(achievement.ascii().get_data());
		return SteamUserStats()->StoreStats();
	}
	return false;
}

bool SteamHandler::clear_steam_achievement(String achievement){
	if (is_steam_user_stats_on() && is_steam_user_on()){
		SteamUserStats()->ClearAchievement(achievement.ascii().get_data());
		return SteamUserStats()->StoreStats();
	}
	return false;

}

bool SteamHandler::indicate_steam_achievement_progress(String achievement, int current_progress, int max_progress)
{
	if (is_steam_user_stats_on() && is_steam_user_on())
	{
		if (SteamUserStats()->IndicateAchievementProgress( achievement.ascii(), current_progress, max_progress ))
		{
			return SteamUserStats()->StoreStats();
		}
	}
	
	return false;

}

bool SteamHandler::set_steam_int_stat(String stat, int value)
{
	return SteamUserStats()->SetStat(stat.ascii(), value);
}

bool SteamHandler::set_steam_float_stat(String stat, float value)
{
	return SteamUserStats()->SetStat(stat.ascii(), value);
}

bool SteamHandler::store_stats()
{
	return SteamUserStats()->StoreStats();
}

bool SteamHandler::reset_all_steam_stats(bool achievements_too)
{
	if (is_steam_user_stats_on() && is_steam_user_on())
	{
		return SteamUserStats()->ResetAllStats(achievements_too);
	}
	
	return false;

}

int SteamHandler::get_int_stat(String stat)
{
    int32_t return_value;
    if (!SteamUserStats()->GetStat(stat.ascii(), &return_value))
    {
	    return -1;
    }
    return return_value;
}

bool SteamHandler::request_current_stats()
{
    if (is_steam_user_on() && is_steam_user_stats_on())
    {
	return SteamUserStats()->RequestCurrentStats();
    }
    return false;
}

bool SteamHandler::get_achievement(String achievement)
{
    bool achieved;
    if (is_steam_user_on() && is_steam_user_stats_on())
    {
	SteamUserStats()->GetAchievement(achievement.ascii(), &achieved);
    }
    return achieved;
}

