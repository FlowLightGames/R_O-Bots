extends CanvasLayer
class_name DrawOverlay

@export var can_move_on:bool=false


func end_and_change_scene()->void:
	MultiplayerStatus.Current_Loaded_Map=null
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_LOBBY
		get_tree().change_scene_to_packed(SceneCollection.online_lobby)
	else:
		get_tree().change_scene_to_packed(SceneCollection.stage_select)

func _process(delta:float)->void:
	if can_move_on:
		if Input.is_action_just_pressed("ui_accept")||Input.is_action_just_pressed("ui_cancel"):
			end_and_change_scene()
