extends Node2D
class_name MultiplayerCustomLobby

@export var player_boxes:Array[LobbyCharacterCustom]
@export var lobby_name_label:Label
@export var stage_select_button:Button

func _ready()->void:
	
	PackageDeconstructor.player_initial_data_transfer_ack.connect(init_player)
	
	PackageDeconstructor.character_custom_data_update.connect(on_character_custom_data_update)
	PackageDeconstructor.character_custom_finished.connect(finished_character_custom)
	
	MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_LOBBY
	
	if !SteamLobby.is_host:
		stage_select_button.free()
	else:
		stage_select_button.disabled=false
		
	apply_player_configs()
	##MultiplayerSpecific:
	
	lobby_name_label.text=str(SteamLobby.lobby_id)

func apply_player_configs()->void:
	for i:int in PlayerConfigs.Player_Configs.size():
		var metadata:PlayerConfigMetaData=PlayerConfigs.Player_Configs[i]
		if metadata.steam_id != -1:
			player_boxes[i].enable()
			player_boxes[i].player_tag.text=Steam.getFriendPersonaName(metadata.steam_id)
		else:
			player_boxes[i].disable()

func check_all_ready()->bool:
	for n:LobbyCharacterCustom in player_boxes:
		if !n.disabled:
			if !n.player_ready:
				return false
	return true

func player_is_ready(player:int)->void:
	#check if all players are ready
	if check_all_ready():
		stage_select_button.disabled=false
	else:
		stage_select_button.disabled=true

func init_player(player:int)->void:
	if player>=0&&player<player_boxes.size():
		player_boxes[player].enable()

func on_character_custom_data_update(player_number:int,ready:bool,face_custom:bool,data:Array[int])->void:
	if player_number in range(0,player_boxes.size()):
		player_boxes[player_number].apply_character_custom_update(ready,face_custom,data)

func _on_cancel_pressed()->void:
	SteamLobby.leave_lobby()
	get_tree().change_scene_to_packed(SceneCollection.main_menu)

func finished_character_custom()->void:
	MultiplayerStatus.Current_Loaded_Map=null
	get_tree().change_scene_to_packed(SceneCollection.stage_select)

func _on_stage_select_pressed()->void:
	if check_all_ready():
		var msg:PackedByteArray=PackageConstructor.character_custom_finished_master(PlayerConfigs.Player_Configs)
		SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE, msg)
		
		get_tree().change_scene_to_packed(SceneCollection.stage_select)


func _on_leave_lobby_pressed()->void:
	get_tree().change_scene_to_packed(SceneCollection.main_menu)
