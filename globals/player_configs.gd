extends Node

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
func reset_player_start_stats()->void:
	for n:PlayerConfigMetaData in Player_Configs:
		n.Starting_Stats=PickUpStats.new()
