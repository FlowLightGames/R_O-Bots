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
#15: GoToScene (FromHost)

signal player_initial_data_transfer_ack(player_number:int)
signal player_number_assignment_ack(player_number:int)
signal player_master_list

#in customizer lobby signals
signal character_custom_finished
signal character_custom_data_update(player_number:int,ready:bool,face_custom:bool,data:Array[int])

signal chat_message(sender_steam_id:int,player_number:int,message:String)
#host selected map:
signal stage_selected(seed:int,package_delay:int,selected_map_index:int,selected_map_size:int)
#multiplayer ingame signals
signal player_state_update(who_steam_id:int,elapsed_time:int,player_state:PlayerState) 
signal game_state_update(who_steam_id:int,elapsed_time:int,game_state:GameState) 
signal round_end(who_steam_id:int,elapsed_time:int,winner_num:int) 
#signal go_to_scene(who_steam_id:int,scene:SceneCollection.ONLINE_SCENES)

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
					var req_steam_id:int=packet_sender
					var test:int=SteamLobby.add_player_assignment(req_steam_id)
					print("sending assignment !=0: "+str(test))
					if test>0:
						var msg:PackedByteArray=PackageConstructor.player_number_assignment(test)
						print("add req delay buffer: "+str(req_steam_id))
						SteamLobby.add_delay_measure_req(req_steam_id)
						SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
				1:
					print("got initial data request")
					var req_steam_id:int=packet_sender
					print("sending initial data request from: "+str(SteamLobby.player_number))
					var msg:PackedByteArray=PackageConstructor.initial_data_transfer(SteamLobby.player_number)
					SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
				2:
					print("got handshake request")
					var req_steam_id:int=packet_sender
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
					var steamID:int=packet_sender
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
						var msg:PackedByteArray=PackageConstructor.initial_data_req()
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
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE, master_player_list)
			
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
			var dict:Dictionary=bytes_to_var(input)
			var player_number:int=dict["PN"]
			var face_custom:bool=dict["FCSTM"]
			var ready:bool=dict["RDY"]
			var data:Array[int]=[dict["BB"],dict["BC"],dict["FB"],dict["FC"]]
			
			character_custom_data_update.emit(player_number,ready,face_custom,data)
			
		5:
			var data_dict:Dictionary=bytes_to_var(input)
			var sender_steamID:int=packet_sender
			var player_number:int=data_dict["PN"]
			var msg:String=data_dict["MSG"]
			chat_message.emit(sender_steamID,player_number,msg)
			#var dict:Dictionary={"SID":sender_steamID,"Pn":player_number,"MSG":msg}
		6:
			#{"RS":random_seed,"PD":package_delay_msec,"STID":stage_index,"STSI":stage_size}
			var data_dict:Dictionary=bytes_to_var(input)
			var package_delay:float=data_dict["PD"]
			var random_seed:int=data_dict["RS"]
			var stage_index:int=data_dict["STID"]
			var stage_size:int=data_dict["STSI"]
			
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
			
			#var self_steamID:int=GlobalSteam.steam_id
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
			#we go playerstate from non pc characers
			var dict:Dictionary=bytes_to_var(input)
			var who_steam_id:int=packet_sender
			var elapsed_time:int=dict["ET"]
			var player_state:PlayerState=PlayerState.new()
			player_state.deserialize(dict["PS"])
			player_state_update.emit(who_steam_id,elapsed_time,player_state)
		13:
			#we got gamestate update from host
			var dict:Dictionary=bytes_to_var(input)
			var who_steam_id:int=packet_sender
			var elapsed_time:int=dict["ET"]
			var game_state:GameState=GameState.new()
			game_state.deserialize(dict["GS"])
			game_state_update.emit(who_steam_id,elapsed_time,game_state)
		14:
			#we got round end from host:
			var dict:Dictionary=bytes_to_var(input)
			var who_steam_id:int=packet_sender
			var elapsed_time:int=dict["ET"]
			var re_dict:Dictionary=dict["RE"]
			var win_number:int=re_dict["WN"]
			round_end.emit(who_steam_id,elapsed_time,win_number)
		15:
			pass
			#var scene_to_go_to:SceneCollection.ONLINE_SCENES=bytes_to_var(input)
			#var who_steam_id:int=packet_sender
			#go_to_scene.emit(who_steam_id,scene_to_go_to)
		_:
			pass
