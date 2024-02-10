extends Resource
class_name PlayerConfig

@export var Body_Base:int=0
@export var Body_Color:int=0
@export var Face_color:int=0
@export var Face_Texture:Texture2D=null
@export var Starting_Stats:PickUpStats=PickUpStats.new()

func _init(bodybase:int=0,bodycolor:int=0,facecolor:int=3,facetexture:Texture2D=FacesAutoload.preset_faces[0],startingtats:PickUpStats=PickUpStats.new())->void:
	Body_Base=bodybase
	Body_Color=bodycolor
	Face_color=facecolor
	Face_Texture=facetexture
	Starting_Stats=startingtats
