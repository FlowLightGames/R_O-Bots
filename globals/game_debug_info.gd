extends CanvasLayer

@export var text:RichTextLabel

func _process(delta:float)->void:
	text.text=("steamID: "+str(GlobalSteam.steam_id)+'\n'
	+"steamName: "+str(GlobalSteam.steam_username)+'\n'
	+"SteamLobbyPlayerNum: "+str(SteamLobby.player_number)+'\n'
	+"MultiplayerSTATE: "+str(MultiplayerStatus.STATE.find_key(MultiplayerStatus.Current_Status))+'\n'
	+"Current rand seed: "+str(SteamLobby.random_seed)+'\n'
	+"is_host: "+str(SteamLobby.is_host)+'\n'
	+"current lobby members: "+str(SteamLobby.lobby_members)+'\n'
	+"current multiplayer_map: "+str(MultiplayerStatus.Current_Loaded_Map)+'\n'
	+"current number of players: "+str(MultiplayerStatus.Current_Number_Of_Players)+'\n'
	+"multiplayer_sync timer running: "+str(!MultiplayerStatus.multiplayer_sync_timer.is_stopped())+'\n'
	+"player_assignment_dict: "+str(SteamLobby.player_assignment_dict)+'\n'
)
