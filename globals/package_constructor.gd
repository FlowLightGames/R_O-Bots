extends Node


#first byte =type
#0: Rquests
	#0 player number assignment
	#1 send me yourinitial data
	#2 handshake
#1: Acknoledgement
	#0 initial player number assignment
	#1 initial data transfer
	#2 handshake
#2: initial data transfer for a lobby (custom faces,etc)
#3: Player Config Master List Update
#4: Character data update
#5: Character ready tru/false (if true send also character config)
#6: lobby start game data (Random Seed)
#7: game state update
#8: finished game
#9: assign playernumber
#10: clock sync (estimate tcp,udp delay)
#11: Character Custom Finished Master

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

func character_data_update(body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,self_player_number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(4)
	output.append(self_player_number)
	
	output.append(body_base)
	output.append(body_color)
	output.append(face_base)
	output.append(face_color)
	output.append(face_custom)
	
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func character_ready(body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,ready:bool,self_player_number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(5)
	output.append(ready)
	output.append(self_player_number)
	if ready:
		output.append(body_base)
		output.append(body_color)
		output.append(face_base)
		output.append(face_color)
		output.append(face_custom)
	
	
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
	output.append(SteamLobby.player_number)
	output.append_array(var_to_bytes(GlobalSteam.steam_id))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_number_assignment(who_steam_id:int,number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(9)
	output.append(number)
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

func character_custom_finished_master(player_configs:Array[PlayerConfigMetaData])->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(11)
	
	var ser_player_configs:Array[Dictionary]=[]
	for n:PlayerConfigMetaData in PlayerConfigs.Player_Configs:
		ser_player_configs.append(n.serialize())
	output.append_array(var_to_bytes(ser_player_configs))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func stage_start_up_master(random_seed:int,package_delay:float)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(6)
	var dict:Dictionary={"RS":random_seed,"PD":package_delay}
	output.append_array(var_to_bytes(dict))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output
