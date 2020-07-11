#include "register_types.h"

#include "core/class_db.h"
#include "steam_handler.h"

void register_steam_handler_types(){
	ClassDB::register_class<SteamHandler>();
}

void unregister_steam_handler_types(){
	//
}
