extends RefCounted
class_name PlayerState

enum ACTIONS{NOTHING,HOOK_FIRED,GUN_FIRED,PEW_FIRED,ZEUS_FIRED,BOMB_PLACED,BOMB_THROW,BOMB_DETONATE}

var player_number:int=0
var dead:bool=false
var moving:bool=false
var position:Vector2=Vector2.ZERO
var reticle_position:Vector2=Vector2.ZERO
var direction:Vector2i=Vector2i.ZERO
var pickup_stats:PickUpStats=PickUpStats.new()
var bombs:Array[BombState]
var taken_action:ACTIONS=ACTIONS.NOTHING

func serialize()->Dictionary:
	var output:Dictionary={}
	output["PN"]=player_number
	output["DED"]=dead
	output["MOV"]=moving
	output["POS"]=position
	output["RPOS"]=reticle_position
	output["DIR"]=direction
	output["PST"]=inst_to_dict(pickup_stats)
	output["TA"]= taken_action
	return output

func deserialize(dict:Dictionary)->void:
	player_number=dict["PN"]
	dead=dict["DED"]
	moving=dict["MOV"]
	position=dict["POS"]
	reticle_position=dict["RPOS"]
	direction=dict["DIR"]
	pickup_stats=dict_to_inst(dict["PST"])
	taken_action=dict["TA"]
