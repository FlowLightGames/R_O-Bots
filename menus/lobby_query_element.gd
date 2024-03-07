extends PanelContainer

var lobby_id:int=0
var host_id:int=0
var host_name:String=""
var font_color:Color=Color(1, 1, 1)
@export
var menu_ref:OnlineLobbyList


func _on_join_pressed()->void:
	menu_ref.join_selected_lobby(lobby_id)
