extends Node

#Audio Settings
var Master:int=100
var Music:int=50
var SFX:int=50

#Video Settings
var Resolution:Vector2i=Vector2i(1920,1080)
var CRT_Filer:bool=false

#SAVE/LOAD
var save_path:String="user://R_O-Bot_Config.save"

func save_data()->void:
	var save_dict:Dictionary={}
	save_dict["Master"]=Master
	save_dict["Music"]=Music
	save_dict["SFX"]=SFX
	
	save_dict["Res"]=Resolution
	save_dict["CRT"]=CRT_Filer
	
	var custom_faces:Array[PackedByteArray]=[]
	for n:Texture2D in FacesAutoload.custom_faces:
		custom_faces.append(FacesAutoload.face_to_bytes(n))
	
	save_dict["CstmFcs"]=custom_faces
	
	var file:FileAccess=FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()

func load_data()->void:
	if FileAccess.file_exists(save_path):
		var file:FileAccess=FileAccess.open(save_path,FileAccess.READ)
		var load_dict:Dictionary=file.get_var()
		
		Master=load_dict["Master"]
		Music=load_dict["Music"]
		SFX=load_dict["SFX"]
		
		Resolution=load_dict["Res"]
		CRT_Filer=load_dict["CRT"]
		
		var custom_face_bytes:Array=load_dict["CstmFcs"] 
		
		var custom_faces:Array[Texture2D]=[]
		for n:PackedByteArray in custom_face_bytes:
			custom_faces.append(FacesAutoload.bytes_to_face(n as PackedByteArray))
		FacesAutoload.custom_faces=custom_faces
		
		file.close()
		
	else:
		Master=100
		Music=50
		SFX=50
		Resolution=Vector2i(1280,720)
		CRT_Filer=false
		FacesAutoload.custom_faces=[]
		save_data()
