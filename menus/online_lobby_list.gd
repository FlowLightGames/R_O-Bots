extends Node2D

class_name OnlineLobbyList

var lobby_query_element:PackedScene=load("res://menus/lobby_query_element.tscn") as PackedScene

@export var lobby_list_node:VBoxContainer

func clear_list()->void:
	for i:Node in lobby_list_node.get_children():
		i.queue_free()

func get_lobbies_with_friends() -> Dictionary:
	var output: Dictionary = {}
	
	for i:int in range(0, Steam.getFriendCount()):
		var results: Dictionary = {}
		var steam_id: int = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)
		if game_info.is_empty():
			# This friend is not playing a game
			continue
		else:
			# They are playing a game, check if it's the same game as ours
			var app_id: int = game_info['id']
			if app_id != GlobalSteam.SteamAppId or game_info['lobby'] is String:
				# Either not in this game, or not in a lobby
				continue
			if not results.has(game_info['lobby']):
				results["friend"] = 0
				
			var lobby_name: String = Steam.getLobbyData(game_info['lobby'], "name")
			
			results["friend"]=steam_id
			results["name"] = lobby_name
			output[game_info['lobby']]=results
	return output

func _on_friend_search_pressed()->void:
	clear_list()
	var friend_lobbys:Dictionary=get_lobbies_with_friends()
	for key:int in friend_lobbys.keys():
		var lobby_info:Dictionary=friend_lobbys[key]
		var lobby_name:String=lobby_info["name"]
		var friend_ids:Array[int]=lobby_info["friend"]
		var max_members:int= Steam.getLobbyMemberLimit(key)
		var current_members:int=Steam.getNumLobbyMembers(key)
		var host_id:int=Steam.getLobbyOwner(key)
		
		var tmp_element:LobbyQueryElement=lobby_query_element.instantiate() as LobbyQueryElement
		
		tmp_element.menu_ref=self
		tmp_element.lobby_name=lobby_name
		tmp_element.host_id=host_id
		tmp_element.max_player_num=max_members
		tmp_element.current_player_num=current_members
		tmp_element.lobby_id=key
		tmp_element.font_color=Color.from_hsv(randf(),1.0,1.0,1.0)

	pass # Replace with function body.


func _on_cancel_pressed()->void:
	get_tree().change_scene_to_packed(SceneCollection.main_menu)
