extends Resource
class_name PlayerConfigMetaData

@export var Body_Base:int=0
@export var Body_Color:int=0
@export var Face_Color:int=0
@export var Face_Base:int=0
@export var Face_Texture:Texture2D=null
@export var Custom_Face:bool=false
@export var Starting_Stats:PickUpStats=PickUpStats.new()

var initial_data_received:bool=false
var steam_id:int=-1

var custom_faces:Array[Texture2D]=[]
var message_delay_udp:float=0.0
var message_delay_tcp:float=0.0


func _init(bodybase:int=0,bodycolor:int=0,facecolor:int=3,facetexture:Texture2D=FacesAutoload.preset_faces[0],startingtats:PickUpStats=PickUpStats.new())->void:
	Body_Base=bodybase
	Body_Color=bodycolor
	Face_Color=facecolor
	Face_Texture=facetexture
	Starting_Stats=startingtats
