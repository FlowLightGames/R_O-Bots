extends PanelContainer
class_name LobbyQueryElement

var lobby_id:int=0
var host_id:int=0
var lobby_name:String=""
var current_player_num:int=0
var max_player_num:int=0
var font_color:Color=Color(1, 1, 1)

@export var LobbyName:Label
@export var FreeSlots:Label

@export
var menu_ref:OnlineLobbyList

func _ready()->void:
	FreeSlots.text=str(current_player_num)+"/"+str(max_player_num)
	LobbyName.text=lobby_name

func _on_join_pressed()->void:
	menu_ref.join_selected_lobby(lobby_id)
