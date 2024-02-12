extends Node

#first byte =type
#0: different checks
#1: Acknoledgement
	#0 initial data transfer
#2: initial data transfer for a lobby (custom faces,etc)
#3: UNSUSED
#4: Character data update
#5: Character ready tru/false (if true send also character config)
#6: lobby start game data (spawnpoints block placements)
#7: game state update
#8: finished game
#9: assign playernumber
signal player_initial_data_transfer_akk(player_number:int)
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
			var akk_type:int=input[0]
			input.remove_at(0)
			match akk_type:
				0:
					pass
				_:
					pass
		2:
			var player_number:int=input[0]
			input.remove_at(0)
			var custom_faces:Array[Texture2D]=[]
			for n:int in range(0,mini(input.size()/FacesAutoload.bytes_per_face,FacesAutoload.max_number_of_faces)):
				custom_faces.append(FacesAutoload.bytes_to_face(input.slice(n*FacesAutoload.bytes_per_face,(n+1)*FacesAutoload.bytes_per_face)))
			#TODO set relevant variable to array
		3:
			pass
		4:
			#0 (body_base)
			#1 (body_color)
			#2 (face_base)
			#3 (face_color)
			#4 (face_custom)
			var player_numer:int=input[0]
			var character_data:Array[int]=[]
			character_data.append(input[1])
			character_data.append(input[2])
			character_data.append(input[3])
			character_data.append(input[4])
			character_data.append(input[5])
			#TODO set relevant variable to array
		5:
			#0_ ready bool
			#1 (body_base)
			#2 (body_color)
			#3 (face_base)
			#4 (face_color)
			#5 (face_custom)
			var ready:bool=bool(input[0])
			var player_numer:int=input[1]
			var character_data:Array[int]=[]
			character_data.append(input[2])
			character_data.append(input[3])
			character_data.append(input[4])
			character_data.append(input[5])
			character_data.append(input[6])
			#TODO set relevant variable to array
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			var player:int=input[0]
		10:
			pass
		_:
			pass
