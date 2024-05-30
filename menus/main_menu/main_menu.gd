extends Node

var disabled:bool=false
@export var animation_player:AnimationPlayer

#buttons
@export var game_start:TextureButton
@export var battle_start:TextureButton
@export var host_lobby:TextureButton
@export var join_lobby:TextureButton
@export var options:TextureButton

@export var version_label:Label


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.SINGLEPLAYER
	MultiplayerStatus.Current_Number_Of_Players=1
	if !GlobalSteam.steam_init:
		host_lobby.disabled=true
		join_lobby.disabled=true
	disabled=false
	version_label.text=ProjectSettings.get_setting("application/config/version")
	animation_player.play("Default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass

func _on_game_start_pressed()->void:
	pass
	#if !disabled:
		#MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.SINGLEPLAYER
		#MultiplayerStatus.Current_Number_Of_Players=1
		#disabled=true
		#SteamLobby.is_host=true

func _on_host_lobby_pressed()->void:
	if !disabled:
		
		disabled=true
		SteamLobby.create_lobby()
		await Steam.lobby_created
		
		PlayerConfigs.reset_full()
		
		MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_LOBBY
		MultiplayerStatus.Current_Number_Of_Players=1
		
		PlayerConfigs.set_player_custom_faces(0,FacesAutoload.custom_faces)
		PlayerConfigs.set_steamID(0,GlobalSteam.steam_id)
		PlayerConfigs.set_player_initial_data_ack(0)
		
		get_tree().change_scene_to_packed(SceneCollection.online_lobby)


func _on_join_lobby_pressed()->void:
	if !disabled:
		PlayerConfigs.reset_full()
		MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.SEARCH_LOBBY
		MultiplayerStatus.Current_Number_Of_Players=1
		disabled=true
		SteamLobby.is_host=false
		get_tree().change_scene_to_packed(SceneCollection.lobby_search)


func _on_battle_start_pressed()->void:
	if !disabled:
		PlayerConfigs.reset_full()
		MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.OFFLINE_MULTIPLAYER
		MultiplayerStatus.Current_Number_Of_Players=1
		disabled=true
		SteamLobby.is_host=true
		get_tree().change_scene_to_packed(SceneCollection.offline_lobby)


func _on_options_pressed()->void:
	if !disabled:
		MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.SINGLEPLAYER
		MultiplayerStatus.Current_Number_Of_Players=1
		disabled=true
		SteamLobby.is_host=true
		get_tree().change_scene_to_packed(SceneCollection.options)

func _on_exit_pressed()->void:
	get_tree().quit()



