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
#latest recieved message timestamp in clinet time
var elapsed_time:int=0
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

func serialize()->Dictionary:
	var serialized_faces:Array[PackedByteArray]=[]
	for n:Texture2D in custom_faces:
		serialized_faces.append(FacesAutoload.face_to_bytes(n))
	
	var output:Dictionary={}
	output["BB"]=Body_Base
	output["BC"]=Body_Color
	output["FB"]=Face_Base
	output["FC"]=Face_Color
	output["CF"]=serialized_faces
	output["SI"]=steam_id
	
	return output

func deserialize(input:Dictionary)->void:
	var deserialized_faces:Array[Texture2D]=[]
	for n:PackedByteArray in input["CF"]:
		deserialized_faces.append(FacesAutoload.bytes_to_face(n))
	
	Body_Base=input["BB"]
	Body_Color=input["BC"]
	Face_Base=input["FB"]
	Face_Color=input["FC"]
	Body_Base=input["BB"]
	steam_id=input["SI"]
	custom_faces=deserialized_faces
