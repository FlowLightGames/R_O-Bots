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
#5: Character ready tru/false (if true send also character config)
#6: lobby start game data (Random Seed,stage selected,package delay)
#7: game state update (from host)
#8: finished game
#9: assign playernumber
#10: clock sync (estimate tcp,udp delay)
#11: Character Custom Finished Master
#12: PlayerStateUpdate (from clients)

signal player_initial_data_transfer_ack(player_number:int)
signal player_number_assignment_ack(player_number:int)
signal player_master_list

#in customizer lobby signals
signal character_custom_finished
signal character_custom_data_update(player_number:int,data:Array[int])
signal character_custom_ready_update(player_number:int,ready:bool,data:Array[int])
#host selected map:
signal stage_selected(seed:int,package_delay:int,selected_map_index:int,selected_map_size:int)
#multiplayer ingame signals
signal player_state_update(who_steam_id:int,elapsed_time:int,player_state:PlayerState) 

func handle_data(input:PackedByteArray,packet_sender:int)->void:
	var type:int=input.decode_u8(0)
	input.remove_at(0)
	match type:
		0:
			var req_type:int=input.decode_u8(0)
			input.remove_at(0)
			match req_type:
				0:
					print("got player number assignment request")
					var req_steam_id:int=bytes_to_var(input)
					var test:int=SteamLobby.add_player_assignment(req_steam_id)
					print("sending assignment !=0: "+str(test))
					if test>0:
						var msg:PackedByteArray=PackageConstructor.player_number_assignment(test)
						print("add req delay buffer: "+str(req_steam_id))
						SteamLobby.add_delay_measure_req(req_steam_id)
						SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
				1:
					print("got initial data request")
					var req_steam_id:int=bytes_to_var(input)
					print("sending initial data request from: "+str(SteamLobby.player_number))
					var msg:PackedByteArray=PackageConstructor.initial_data_transfer(SteamLobby.player_number)
					SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
				2:
					print("got handshake request")
					var req_steam_id:int=bytes_to_var(input)
					var msg:PackedByteArray=PackageConstructor.handshake_ack()
					SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
		1:
			var ack_type:int=input.decode_u8(0)
			input.remove_at(0)
			var data:PackedByteArray=input
			match ack_type:
				0:
					var dict:Dictionary=bytes_to_var(data) as Dictionary
					var player_number:int=dict["PN"]
					var steamID:int=dict["SID"]
					var elapsed_time:int=dict["ET"]
					var measure_delay_time:int=SteamLobby.on_delay_measure_ack(steamID)
					if measure_delay_time==0:
						#TODO FAIL PANIC WORLD END
						print("END OF THE WORLD, 0 DELAY, IMPOSSSIBRU, WAAAAAAAAAAAAA. or didnt send a delay request before")
					
					PlayerConfigs.set_steamID(player_number,steamID)
					PlayerConfigs.set_package_delay(player_number,measure_delay_time)
					PlayerConfigs.set_elapsed_time(player_number,elapsed_time)
					print("got number assignment ack: "+str(player_number))
					
					player_number_assignment_ack.emit(player_number)
					if player_number!=0:
						var msg:PackedByteArray=PackageConstructor.initial_data_req(GlobalSteam.steam_id)
						SteamLobby.send_p2p_packet(steamID,Steam.P2P_SEND_RELIABLE,msg)
				1:
					
					var player_number:int=data.decode_u8(0)
					data.remove_at(0)
					print("got initial data ack: "+str(player_number))
					player_initial_data_transfer_ack.emit(player_number)
				2:
					print("got handshake ack")
				_:
					pass
		2:
			
			var player_number:int=input.decode_u8(0)
			input.remove_at(0)
			print("got initial data transfer from: "+str(player_number))
			var custom_faces:Array[Texture2D]=[]
			for n:int in range(0,mini(input.size()/FacesAutoload.bytes_per_face,FacesAutoload.max_custom_faces)):
				custom_faces.append(FacesAutoload.bytes_to_face(input.slice(n*FacesAutoload.bytes_per_face,(n+1)*FacesAutoload.bytes_per_face)))
			PlayerConfigs.set_player_custom_faces(player_number,custom_faces)
			PlayerConfigs.set_player_initial_data_ack(player_number)
			
			var master_player_list:PackedByteArray=PackageConstructor.player_config_master_list(PlayerConfigs.Player_Configs)
			for member:Dictionary in SteamLobby.lobby_members:
				if member.has("steam_id"):
					if member["steam_id"]!=GlobalSteam.steam_id:
						SteamLobby.send_p2p_packet(member["steam_id"],Steam.P2P_SEND_RELIABLE, master_player_list)
			
			var ack_msg:PackedByteArray=PackageConstructor.initial_data_ack(player_number)
			SteamLobby.send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE, ack_msg)
		3:
			var ser_player_configs:Array=bytes_to_var(input)
			for n:int in ser_player_configs.size():
				PlayerConfigs.Player_Configs[n].deserialize(ser_player_configs[n] as Dictionary)
				PlayerConfigs.Player_Configs[n].initial_data_received=true
			print("got player config master list")
			player_master_list.emit()
		4:
			#we are host and got player ready signal from client
			#0 (body_base)
			#1 (body_color)
			#2 (face_base)
			#3 (face_color)
			#4 (face_custom)
			var player_number:int=input.decode_u8(0)
			var character_data:Array[int]=[]
			character_data.append(input.decode_u8(1))
			character_data.append(input.decode_u8(2))
			character_data.append(input.decode_u8(3))
			character_data.append(input.decode_u8(4))
			character_data.append(input.decode_u8(5))
			PlayerConfigs.update_player_config(player_number,character_data)
			
		5:
			print("got player is ready data")
			#0_ ready bool
			#1 (body_base)
			#2 (body_color)
			#3 (face_base)
			#4 (face_color)
			#5 (face_custom)
			var ready:bool=bool(input.decode_u8(0))
			var player_number:int=input.decode_u8(1)
			var character_data:Array[int]=[]
			character_data.append(input.decode_u8(2))
			character_data.append(input.decode_u8(3))
			character_data.append(input.decode_u8(4))
			character_data.append(input.decode_u8(5))
			character_data.append(input.decode_u8(6))
			PlayerConfigs.update_player_confi(player_number,character_data)
			#TODO set rady var in relevant script
		6:
			#{"RS":random_seed,"PD":package_delay_msec,"STID":stage_index,"STSI":stage_size}
			var data_dict:Dictionary=bytes_to_var(input)
			var package_delay:float=data_dict["PD"]
			var random_seed:int=data_dict["RS"]
			var stage_index:int=data_dict["STID"]
			var stage_size:int=data_dict["STSI"]
			
			MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_MULTIPLAYER
			stage_selected.emit(random_seed,package_delay,stage_index,stage_size)
		7:
			pass
		8:
			pass
		9:
			print("got player number assignment")
			var player:int=input.decode_u8(0)
			print("got player number assignment to: "+str(player))
			SteamLobby.player_number=player
			
			var self_steamID:int=GlobalSteam.steam_id
			#works as well: but to keep it consistent top
			#var self_steamID:int=Steam.getSteamID()
			var ack_msg:PackedByteArray=PackageConstructor.player_number_ack()
			SteamLobby.send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE, ack_msg)
		10:
			pass
		11:
			#we are client and got all player configs from host
			var ser_player_configs:Array=bytes_to_var(input)
			for n:int in ser_player_configs.size():
				PlayerConfigs.Player_Configs[n].deserialize(ser_player_configs[n] as Dictionary)
				PlayerConfigs.Player_Configs[n].initial_data_received=true
			print("got player ready config master list")
			character_custom_finished.emit()
		12:
			#we are host and got info from client
			var dict:Dictionary=bytes_to_var(input)
			var who_steam_id:int=dict["SID"]
			var elapsed_time:int=dict["ET"]
			var player_state:PlayerState=PlayerState.new()
			player_state.deserialize(dict["PS"])
			player_state_update.emit(who_steam_id,elapsed_time,player_state)
		_:
			pass
