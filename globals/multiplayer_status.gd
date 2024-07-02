extends Node

enum STATE{ONLINE_LOBBY,SEARCH_LOBBY,SINGLEPLAYER,ONLINE_MULTIPLAYER,OFFLINE_MULTIPLAYER}

@export var multiplayer_sync_timer:Timer

#session settings
#wont be saved
var Current_Number_Of_Players:int=2
var Current_Status:int=STATE.SINGLEPLAYER
var Delay_To_Host_TCP:int=0

var Current_Loaded_Map:MapBase=null

#func _ready()->void:
	#PackageDeconstructor.go_to_scene.connect(_on_go_to_scene)

func start_timer()->void:
	multiplayer_sync_timer.start(0.5)

#func _on_go_to_scene(who_stem_id:int,scene:SceneCollection)->void:
	#if !SteamLobby.is_host:
		#match scene:
			#SceneCollection.ONLINE_SCENES.LOBBY:
				#get_tree().change_scene_to_packed(SceneCollection.online_lobby)
			#SceneCollection.ONLINE_SCENES.STAGE_SELECT:
				#get_tree().change_scene_to_packed(SceneCollection.stage_select)

func _on_multiplayer_sync_timer_timeout()->void:
	if Current_Loaded_Map:
		#we're the host
		if SteamLobby.is_host:
			var msg:PackedByteArray=PackageConstructor.game_state_update(Current_Loaded_Map.get_game_state())
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_UNRELIABLE_NO_DELAY,msg)
		#we're not the host
		else:
			pass
			#var msg:PackedByteArray=PackageConstructor.player_state_update(Current_Loaded_Map.get_playerstate(SteamLobby.player_number),GlobalSteam.steam_id)
			#SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_UNRELIABLE,msg)
