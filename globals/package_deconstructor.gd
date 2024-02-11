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

func handle_data(input:PackedByteArray)->void:
	var type:int=input.decode_u8(0)
	input.remove_at(0)
	match type:
		0:
			pass
		1:
			pass
		2:
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
			var character_data:Array[int]=[]
			character_data.append(input[0])
			character_data.append(input[1])
			character_data.append(input[2])
			character_data.append(input[3])
			character_data.append(input[4])
			#TODO set relevant variable to array
		5:
			#0_ ready bool
			#1 (body_base)
			#2 (body_color)
			#3 (face_base)
			#4 (face_color)
			#5 (face_custom)
			var ready:bool=bool(input[0])
			var character_data:Array[int]=[]
			character_data.append(input[1])
			character_data.append(input[2])
			character_data.append(input[3])
			character_data.append(input[4])
			character_data.append(input[5])
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
