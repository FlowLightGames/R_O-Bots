extends Node


#first byte =type
#0: Rquests
	#0 player number assignment also measuer package delay with ack
	#1 send me yourinitial data
	#2 handshake
#1: Acknoledgement
	#0 initial player number assignment
	#1 initial data transfer
	#2 handshake
#2: initial data transfer for a lobby (custom faces,etc)
#3: Player Config Master List Update
#4: Character data update
#5: Lobby_ChatMessage
#6: lobby start game data (Random Seed,stage selected,package delay)
#7: game state update (from host)
#8: finished game
#9: assign playernumber
#10: clock sync (estimate tcp,udp delay)
#11: Character Custom Finished Master
#12: PlayerStateUpdate (from everyone to everyone)
#13: GameStateUpdate (from host to clients)
#14: RoundEnd (from host to clients)

func handshake_req(reqester_steam_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(0)
	output.append(2)
	output.append_array(var_to_bytes(reqester_steam_id))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func handshake_ack()->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(1)
	output.append(2)
	output.append_array(var_to_bytes(GlobalSteam.steam_id))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func initial_data_req(self_requester_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(0)
	output.append(1)
	output.append_array(var_to_bytes(self_requester_id))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func initial_data_ack(player_number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(1)
	output.append(1)
	output.append(player_number)
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func initial_data_transfer(self_player_number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(2)
	output.append(self_player_number)
	for n:int in range(0,min(FacesAutoload.max_custom_faces,FacesAutoload.custom_faces.size())):
		output.append_array(FacesAutoload.face_to_bytes(FacesAutoload.custom_faces[n]))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_config_master_list(player_configs:Array[PlayerConfigMetaData])->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(3)
	
	var ser_player_configs:Array[Dictionary]=[]
	for n:PlayerConfigMetaData in PlayerConfigs.Player_Configs:
		ser_player_configs.append(n.serialize())
	output.append_array(var_to_bytes(ser_player_configs))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func character_data_update(body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,self_player_number:int,ready:bool)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(4)
	var output_dict:Dictionary={
		"PN":self_player_number,
		"BB":body_base,
		"BC":body_color,
		"FB":face_base,
		"FC":face_color,
		
		"RDY":ready,
		"FCSTM":face_custom
	}
	output.append_array(var_to_bytes(output_dict))
	
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func lobby_chat_message(sender_steamID:int,player_number:int,msg:String)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(5)
	var dict:Dictionary={"SID":sender_steamID,"PN":player_number,"MSG":msg}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func stage_start_up_master(random_seed:int,package_delay_msec:int,stage_index:int,stage_size:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(6)
	var dict:Dictionary={"RS":random_seed,"PD":package_delay_msec,"STID":stage_index,"STSI":stage_size}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_number_req(who_steam_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(0)
	output.append(0)
	output.append_array(var_to_bytes(who_steam_id))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_number_ack()->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(1)
	output.append(0)
	var output_dict:Dictionary={"PN":SteamLobby.player_number,"SID":GlobalSteam.steam_id,"ET":Time.get_ticks_msec()}
	output.append_array(var_to_bytes(output_dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_number_assignment(number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(9)
	output.append(number)
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func character_custom_finished_master(player_configs:Array[PlayerConfigMetaData])->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(11)
	
	var ser_player_configs:Array[Dictionary]=[]
	for n:PlayerConfigMetaData in PlayerConfigs.Player_Configs:
		ser_player_configs.append(n.serialize())
	output.append_array(var_to_bytes(ser_player_configs))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output


func player_state_update(player_state:PlayerState,who_steam_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(12)
	var dict:Dictionary={"SID":who_steam_id,"ET":Time.get_ticks_msec(),"PS":player_state.serialize()}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func game_state_update(game_state:GameState,who_steam_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(13)
	var dict:Dictionary={"SID":who_steam_id,"ET":Time.get_ticks_msec(),"GS":game_state.serialize()}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func round_end(winner_num:int,who_steam_id:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(14)
	var round_end_dict:Dictionary={"WN":winner_num}
	var dict:Dictionary={"SID":who_steam_id,"ET":Time.get_ticks_msec(),"RE":round_end_dict}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output
