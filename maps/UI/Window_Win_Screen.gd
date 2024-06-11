extends Node
class_name WindowWinOverlay

var player_scene:PackedScene=load("res://player_character/character.tscn")
@export var player_node:Node2D
@export var can_move_on:bool=false

func set_winner(player_config:PlayerConfigMetaData)->void:
	var tmp_char:PlayerCharacter=player_scene.instantiate() as PlayerCharacter
	tmp_char.config_init(player_config)
	player_node.add_child(tmp_char)
	tmp_char.disabled=true
	tmp_char.BodyAnimation.play("jump_front_left")
#
#func _ready()->void:
	#set_winner(PlayerConfigs.Player_Configs[7])

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


func _on_timer_timeout()->void:
	can_move_on=true
