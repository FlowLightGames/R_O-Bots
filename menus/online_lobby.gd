extends Node2D
class_name MultiplayerCustomLobby

@export var player_boxes:Array[LobbyCharacterCustom]

func _ready()->void:
	for n:LobbyCharacterCustom in player_boxes:
		n.disable()
	player_boxes[0].enable()
	##MultiplayerSpecific:
	PackageDeconstructor.player_initial_data_transfer_ack.connect(init_player)

func init_player(player:int)->void:
	if player>=0&&player<player_boxes.size():
		player_boxes[player].enable()
