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


func initial_data_transfer()->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(2)
	for n:int in range(0,min(FacesAutoload.max_number_of_faces,FacesAutoload.custom_faces.size())):
		output.append_array(FacesAutoload.face_to_bytes(FacesAutoload.custom_faces[n]))
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func character_data_update(body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(4)
	output.append(body_base)
	output.append(body_color)
	output.append(face_base)
	output.append(face_color)
	output.append(face_custom)
	
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func character_ready(body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,ready:bool)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(5)
	output.append(ready)
	if ready:
		output.append(body_base)
		output.append(body_color)
		output.append(face_base)
		output.append(face_color)
		output.append(face_custom)
	
	
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output

func player_number_assignment(number:int)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	output.append(9)
	output.append(number)
	output=output.compress(FileAccess.COMPRESSION_GZIP)
	return output



