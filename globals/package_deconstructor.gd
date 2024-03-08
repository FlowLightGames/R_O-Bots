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
#3: UNSUSED
#4: Character data update
#5: Character ready tru/false (if true send also character config)
#6: lobby start game data (spawnpoints block placements)
#7: game state update
#8: finished game
#9: assign playernumber
#10: clock sync (estimate tcp,udp delay)

signal player_initial_data_transfer_ack(player_number:int)
signal player_number_assignment_ack(player_number:int)
signal character_custom_data_update(player_number:int,data:Array[int])
signal character_custom_ready_update(player_number:int,ready:bool,data:Array[int])

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
					if test>=0:
						var msg:PackedByteArray=PackageConstructor.player_number_assignment(req_steam_id,test)
						SteamLobby.send_p2p_packet(req_steam_id,Steam.P2P_SEND_RELIABLE, msg)
				1:
					print("got initial data request")
					var req_steam_id:int=bytes_to_var(input)
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
			var player_number:int=input.decode_u8(0)
			input.remove_at(0)
			var data:PackedByteArray=input
			match ack_type:
				0:
					print("got number assignment ack")
					var steamID:int=bytes_to_var(data)
					PlayerConfigs.set_steamID(player_number,steamID)
					player_number_assignment_ack.emit(player_number)
				1:
					print("got initial data ack")
					player_initial_data_transfer_ack.emit(player_number)
				2:
					print("got handshake ack")
				_:
					pass
		2:
			print("got initial data transfer")
			var player_number:int=input.decode_u8(0)
			input.remove_at(0)
			var custom_faces:Array[Texture2D]=[]
			for n:int in range(0,mini(input.size()/FacesAutoload.bytes_per_face,FacesAutoload.max_number_of_faces)):
				custom_faces.append(FacesAutoload.bytes_to_face(input.slice(n*FacesAutoload.bytes_per_face,(n+1)*FacesAutoload.bytes_per_face)))
			PlayerConfigs.set_player_custom_faces(player_number,custom_faces)
			PlayerConfigs.set_player_initial_data_ack(player_number)
			var ack_msg:PackedByteArray=PackageConstructor.player_ack(player_number,1)
			SteamLobby.send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE, ack_msg)
		3:
			pass
		4:
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
			pass
		7:
			pass
		8:
			pass
		9:
			print("got player number assignment")
			var player:int=input.decode_u8(0)
			SteamLobby.player_number=player
			
			var self_steamID:int=GlobalSteam.steam_id
			#works as well: but to keep it consistent top
			#var self_steamID:int=Steam.getSteamID()
			var ack_msg:PackedByteArray=PackageConstructor.player_ack(player,0,var_to_bytes(self_steamID))
			SteamLobby.send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE, ack_msg)
		10:
			pass
		_:
			pass
