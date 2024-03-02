extends Node2D
class_name MultiplayerCustomLobby

@export var player_boxes:Array[LobbyCharacterCustom]

func _ready()->void:
	for n:LobbyCharacterCustom in player_boxes:
		n.disable()
	player_boxes[0].enable()
	##MultiplayerSpecific:
	PackageDeconstructor.player_initial_data_transfer_ack.connect(init_player)
	PlayerConfigs.player_config_changed.connect(on_character_custom_data_update)

func init_player(player:int)->void:
	if player>=0&&player<player_boxes.size():
		player_boxes[player].enable()

func on_character_custom_data_update(player_number:int)->void:
	player_boxes[player_number].update_character_custom(player_number)
