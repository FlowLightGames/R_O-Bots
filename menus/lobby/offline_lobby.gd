extends Node2D
class_name OfflineCustomLobby

@export var player_boxes:Array[LobbyCharacterCustom]

var num_of_players:int=1

func _ready()->void:
	num_of_players=MultiplayerStatus.Current_Number_Of_Players
	update_player_boxes()

func update_player_boxes()->void:
	for n:int in range(0,player_boxes.size()):
		if n<num_of_players:
			player_boxes[n].enable()
		else:
			player_boxes[n].disable()

func check_all_ready()->bool:
	for n:LobbyCharacterCustom in player_boxes:
		if !n.disabled:
			if !n.player_ready:
				return false
	return true

func init_player(player:int)->void:
	if player>=0&&player<player_boxes.size():
		player_boxes[player].enable()



func _on_add_player_pressed()->void:
	num_of_players=mini(num_of_players+1,GameConfig.Max_Players)
	update_player_boxes()


func _on_remove_player_pressed()->void:
	num_of_players=maxi(num_of_players-1,1)
	update_player_boxes()


func _on_cancel_pressed()->void:
	get_tree().change_scene_to_packed(SceneCollection.main_menu)


func _on_stage_select_pressed()->void:
	#set Playerconfig global
	for n:int in range(0,num_of_players):
		var tmp_face_texture:Texture2D=null
		if player_boxes[n].current_face_custom:
			tmp_face_texture=FacesAutoload.custom_faces[player_boxes[n].current_face_base]
		else:
			tmp_face_texture=FacesAutoload.preset_faces[player_boxes[n].current_face_base]
		var tmp_meta:PlayerConfigMetaData=PlayerConfigMetaData.new(
			player_boxes[n].current_body_base,
			player_boxes[n].current_body_color,
			player_boxes[n].current_face_color,
			tmp_face_texture,
			PickUpStats.new()
		)
		PlayerConfigs.Player_Configs[n]=tmp_meta
	MultiplayerStatus.Current_Number_Of_Players=num_of_players
	#change to stage select
	get_tree().change_scene_to_packed(SceneCollection.stage_select)
