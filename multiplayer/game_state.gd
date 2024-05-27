extends RefCounted
class_name GameState

var alive_players:Array[int]=[]
var destroyables_list:Dictionary={}

func serialize()->Dictionary:
	return {"AP":alive_players,"DESL":destroyables_list}

func deserialize(dict:Dictionary)->void:
	alive_players=dict["AP"]
	destroyables_list=dict["DESL"]
