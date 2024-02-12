extends Node

#first byte =type
#0: different checks
#1: Acknoledgement
	#0 initial player number assignment
	#1 initial data transfer
#2: initial data transfer for a lobby (custom faces,etc)
#3: UNSUSED
#4: Character data update
#5: Character ready tru/false (if true send also character config)
#6: lobby start game data (spawnpoints block placements)
#7: game state update
#8: finished game
#9: assign playernumber
#10: clock sync (estimate tcp,udp delay)

signal player_initial_data_transfer_akk(player_number:int)
signal player_number_assignment_akk(player_number:int)
signal player_number_assignment(number:int)
signal character_custom_data_update(player_number:int,data:Array[int])
signal character_custom_ready_update(player_number:int,ready:bool,data:Array[int])


func handle_data(input:PackedByteArray)->void:
	var type:int=input.decode_u8(0)
	input.remove_at(0)
	match type:
		0:
			pass
		1:
			var akk_type:int=input.decode_u8(0)
			input.remove_at(0)
			var player_number:int=input.decode_u8(0)
			input.remove_at(0)
			var data:PackedByteArray=input
			match akk_type:
				0:
					var steamID:int=bytes_to_var(data)
					PlayerConfigs.set_steamID(player_number,steamID)
					player_number_assignment_akk.emit(player_number)
				1:
					PlayerConfigs.set_player_initial_data_akk(player_number)
				_:
					pass
		2:
			var player_number:int=input.decode_u8(0)
			input.remove_at(0)
			var custom_faces:Array[Texture2D]=[]
			for n:int in range(0,mini(input.size()/FacesAutoload.bytes_per_face,FacesAutoload.max_number_of_faces)):
				custom_faces.append(FacesAutoload.bytes_to_face(input.slice(n*FacesAutoload.bytes_per_face,(n+1)*FacesAutoload.bytes_per_face)))
			PlayerConfigs.set_player_custom_faces(player_number,custom_faces)
			
			var akk_msg:PackedByteArray=PackageConstructor.player_akk(player_number,1)
			SteamLobby.send_p2p_packet(-1,2, akk_msg)
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
			PlayerConfigs.update_player_confi(player_number,character_data)
		5:
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
			var player:int=input.decode_u8(0)
			SteamLobby.player_number=player
			
			var self_steamID:int=Steam.getSteamID()
			var akk_msg:PackedByteArray=PackageConstructor.player_akk(player,0,var_to_bytes(self_steamID))
			SteamLobby.send_p2p_packet(-1,2, akk_msg)
		10:
			pass
		_:
			pass
