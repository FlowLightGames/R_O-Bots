extends Node2D
class_name MultiplayerCustomLobby

@export var player_boxes:Array[LobbyCharacterCustom]
@export var lobby_id_label:Label

func _ready()->void:
	for n:LobbyCharacterCustom in player_boxes:
		n.disable()
	player_boxes[0].enable()
	##MultiplayerSpecific:
	PackageDeconstructor.player_initial_data_transfer_ack.connect(init_player)
	PlayerConfigs.player_config_changed.connect(on_character_custom_data_update)
	lobby_id_label.text=str(SteamLobby.lobby_id)

func init_player(player:int)->void:
	if player>=0&&player<player_boxes.size():
		player_boxes[player].enable()

func on_character_custom_data_update(player_number:int)->void:
	player_boxes[player_number].update_character_custom(player_number)


func _on_cancel_pressed()->void:
	SteamLobby.leave_lobby()
	get_tree().change_scene_to_packed(SceneCollection.main_menu)
