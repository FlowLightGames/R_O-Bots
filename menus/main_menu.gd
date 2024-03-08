extends Node

var disabled:bool=false

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	disabled=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass


func _on_host_lobby_pressed()->void:
	if !disabled:
		disabled=true
		SteamLobby.create_lobby()
		await Steam.lobby_created
		get_tree().change_scene_to_packed(SceneCollection.online_lobby)


func _on_join_lobby_pressed()->void:
	if !disabled:
		disabled=true
		get_tree().change_scene_to_packed(SceneCollection.lobby_search)
