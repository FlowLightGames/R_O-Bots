extends Node

signal player_config_changed(player_number:int)

var Player_Configs:Array[PlayerConfigMetaData]=[
	PlayerConfigMetaData.new(0,0,0,FacesAutoload.preset_faces[0],PickUpStats.new()),
	PlayerConfigMetaData.new(0,1,1,FacesAutoload.preset_faces[1],PickUpStats.new()),
	PlayerConfigMetaData.new(0,2,2,FacesAutoload.preset_faces[2],PickUpStats.new()),
	PlayerConfigMetaData.new(0,3,3,FacesAutoload.preset_faces[3],PickUpStats.new()),
	
	PlayerConfigMetaData.new(0,4,4,FacesAutoload.preset_faces[4],PickUpStats.new()),
	PlayerConfigMetaData.new(0,5,5,FacesAutoload.preset_faces[5],PickUpStats.new()),
	PlayerConfigMetaData.new(0,6,6,FacesAutoload.preset_faces[6],PickUpStats.new()),
	PlayerConfigMetaData.new(0,7,7,FacesAutoload.preset_faces[7],PickUpStats.new()),
]

func reset_full()->void:
	Player_Configs=[
	PlayerConfigMetaData.new(0,0,0,FacesAutoload.preset_faces[0],PickUpStats.new()),
	PlayerConfigMetaData.new(0,1,1,FacesAutoload.preset_faces[1],PickUpStats.new()),
	PlayerConfigMetaData.new(0,2,2,FacesAutoload.preset_faces[2],PickUpStats.new()),
	PlayerConfigMetaData.new(0,3,3,FacesAutoload.preset_faces[3],PickUpStats.new()),
	
	PlayerConfigMetaData.new(0,4,4,FacesAutoload.preset_faces[4],PickUpStats.new()),
	PlayerConfigMetaData.new(0,5,5,FacesAutoload.preset_faces[5],PickUpStats.new()),
	PlayerConfigMetaData.new(0,6,6,FacesAutoload.preset_faces[6],PickUpStats.new()),
	PlayerConfigMetaData.new(0,7,7,FacesAutoload.preset_faces[7],PickUpStats.new()),
	]

func set_player_custom_faces(player_number:int,data:Array[Texture2D])->void:
	if player_number >=0 && player_number<=7:
		Player_Configs[player_number].custom_faces=data
		
		player_config_changed.emit(player_number)

func update_player_config(player_number:int,data:Array[int])->void:
	if player_number >=0 && player_number<=7:
		if data.size()==5:
			#0 (body_base)
			#1 (body_color)
			#2 (face_base)
			#3 (face_color)
			#4 (face_custom)
			Player_Configs[player_number].Body_Base=data[0]
			Player_Configs[player_number].Body_Color=data[1]
			Player_Configs[player_number].Face_Base=data[2]
			Player_Configs[player_number].Face_Color=data[3]
			Player_Configs[player_number].Custom_Face=bool(data[4])
			if bool(data[4]):
				Player_Configs[player_number].Face_Texture=Player_Configs[player_number].custom_faces[data[2]]
			else:
				Player_Configs[player_number].Face_Texture=FacesAutoload.preset_faces[data[2]]
			
			player_config_changed.emit(player_number)

func set_steamID(player_number:int,steamID:int)->void:
	if player_number >=0 && player_number<=7:
		Player_Configs[player_number].steam_id=steamID

func set_player_initial_data_ack(player_number:int)->void:
	if player_number >=0 && player_number<=7:
		Player_Configs[player_number].initial_data_received=true

func reset_player_start_stats()->void:
	for n:PlayerConfigMetaData in Player_Configs:
		n.Starting_Stats=PickUpStats.new()
