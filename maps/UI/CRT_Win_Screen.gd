extends Node
class_name WinOverlay
var player_scene:PackedScene=load("res://player_character/character.tscn")

@export var player_node:Node2D
@export var animation_player:AnimationPlayer
@export var old_cam:Camera2D
@export var new_cam:Camera2D

func set_winner(player_config:PlayerConfigMetaData)->void:
	var tmp_char:PlayerCharacter=player_scene.instantiate() as PlayerCharacter
	tmp_char.config_init(player_config)
	player_node.add_child(tmp_char)
	tmp_char.disabled=true
	tmp_char.BodyAnimation.play("jump_front_left")
#
#func _ready()->void:
	#set_winner(PlayerConfigs.Player_Configs[7])

func switch_cams()->void:
	if(old_cam):
		old_cam.enabled=false
	new_cam.enabled=true

func _on_transition_finished_transition()->void:
	animation_player.play("Default")
