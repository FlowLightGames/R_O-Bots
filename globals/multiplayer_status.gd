extends Node

enum STATE{HOST_LOBBY,JOINED_LOBBY,SEARCH_LOBBY,SINGLEPLAYER,ONLINE_MULTIPLAYER,OFFLINE_MULTIPLAYER}

@export var sync_timer:Timer

#session settings
#wont be saved
var Online_Session:bool=false
var Current_Number_Of_Players:int=0
var Current_Status:int=STATE.SINGLEPLAYER

var current_loaded_map:MapBase=null


func _on_multiplayer_sync_timer_timeout()->void:
	if current_loaded_map:
		#we're not host
		if !SteamLobby.is_host:
			if Current_Status==STATE.ONLINE_MULTIPLAYER:
				current_loaded_map.get_gamestate()
		#we're the host
		else:
			pass
