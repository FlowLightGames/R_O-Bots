extends RefCounted
class_name GameState

var alive_players:Array[PlayerState]=[]
var destroyables_list:Array[Vector2i]=[]

func serialize()->Dictionary:
	var ser_alive_player:Array[Dictionary]=[]
	for n:PlayerState in alive_players:
		ser_alive_player.append(n.serialize())
	return {"AP":ser_alive_player,"DESL":destroyables_list}

func deserialize(dict:Dictionary)->void:
	var ser_alive_players:Array=dict["AP"]
	var deser_alive_player:Array[PlayerState]=[]
	for n:Dictionary in ser_alive_players:
		var tmp_playerstate:PlayerState=PlayerState.new()
		tmp_playerstate.deserialize(n)
		deser_alive_player.append(tmp_playerstate)
	destroyables_list=dict["DESL"]
