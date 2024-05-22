extends Node

enum STATE{HOST_LOBBY,JOINED_LOBBY,SEARCH_LOBBY,SINGLEPLAYER,ONLINE_MULTIPLAYER,OFFLINE_MULTIPLAYER}

@export var multiplayer_sync_timer:Timer

#session settings
#wont be saved
var Current_Number_Of_Players:int=0
var Current_Status:int=STATE.SINGLEPLAYER

var Current_Loaded_Map:MapBase=null


func _on_multiplayer_sync_timer_timeout()->void:
	if Current_Loaded_Map:
		#we're the host
		if SteamLobby.is_host:
			pass
		#we're not the host
		else:
			if Current_Status==STATE.ONLINE_MULTIPLAYER:
				var msg:PackedByteArray=PackageConstructor.player_state_update(Current_Loaded_Map.get_playerstate(SteamLobby.player_number),GlobalSteam.steam_id)
				SteamLobby.send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE,msg)
