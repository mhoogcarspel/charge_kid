#ifndef STEAM_HANDLER_H
#define STEAM_HANDLER_H

#include <inttypes.h> //without this MinGW doesnt recognize the __int type
			//Why? I dont know
#include "steam_api.h"
#include "core/object.h"

class SteamHandler : public Object {
	GDCLASS(SteamHandler, Object);

	public:

	static void _bind_methods();

	SteamHandler();
	~SteamHandler();

	void _init(); //our initializer called by Godot
	//void _process(float delta);

	bool is_steam_running();
	bool steam_api_init();
	bool is_steam_user_stats_on();
	bool is_steam_user_on();
	bool set_steam_achievement(String achievement);
	bool clear_steam_achievement(String achivement);
	bool indicate_steam_achievement_progress(String achievement, int current_progress, int max_progress);
	bool set_steam_int_stat(String stat, int value);
	bool set_steam_float_stat(String stat, float value);
	bool reset_all_steam_stats(bool achievements_too);
	int get_int_stat(String stat);
	bool request_current_stats();
	bool get_achievement(String achievement);
	bool store_stats();
};

#endif //STEAM_HANDLER_H
