extends PanelContainer

@export var line_input:LineEdit
@export var live_chat:LiveChat


func _on_send_pressed()->void:
	var text:String=line_input.text
	text=text.replace(" ","")
	if !text.is_empty():
		var msg:PackedByteArray=PackageConstructor.lobby_chat_message(GlobalSteam.steam_id,SteamLobby.player_number,line_input.text)
		SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,msg)
		live_chat.spawn_message(GlobalSteam.steam_id,SteamLobby.player_number,line_input.text)
		line_input.clear()


func _on_line_edit_text_submitted(new_text:String)->void:
	var text:String=new_text
	text=text.replace(" ","")
	if !text.is_empty():
		var msg:PackedByteArray=PackageConstructor.lobby_chat_message(GlobalSteam.steam_id,SteamLobby.player_number,new_text)
		SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,msg)
		live_chat.spawn_message(GlobalSteam.steam_id,SteamLobby.player_number,new_text)
		line_input.clear()
