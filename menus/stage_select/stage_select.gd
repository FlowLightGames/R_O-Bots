extends Node2D

@export var stage_label:Label
@export var size_label:Label
@export var stage_preview:StagePreview
@export var stage_select_meta_datas:Array[StageSelectMetaData]


enum Size {
	S,M,L
}

var max_sizes:int=3
var max_stages:int=0

var current_size:Size=Size.M
var current_stage:int=0

func _ready()->void:
	for n:StageSelectMetaData in stage_select_meta_datas:
		n.stage_pickup_map.sort_map()
	
	max_stages=stage_select_meta_datas.size()
	
	current_size=Size.M
	current_stage=0
	apply_new_selection()

func apply_new_selection()->void:
	size_label.text=Size.keys()[current_size]
	stage_label.text=str(current_stage)
	stage_preview.set_tileset_preview(stage_select_meta_datas[current_stage])
	

func _on_stage_dec_pressed()->void:
	if SteamLobby.is_host:
		current_stage=posmod(current_stage-1,max_stages)
		apply_new_selection()


func _on_stage_inc_pressed()->void:
	if SteamLobby.is_host:
		current_stage=posmod(current_stage+1,max_stages)
		apply_new_selection()


func _on_size_dec_pressed()->void:
	if SteamLobby.is_host:
		current_size=posmod(current_size-1,max_sizes)
		apply_new_selection()


func _on_size_inc_pressed()->void:
	if SteamLobby.is_host:
		current_size=posmod(current_size+1,max_sizes)
		apply_new_selection()

func _on_cancel_pressed()->void:
	if GameConfig.Online_Session:
		get_tree().change_scene_to_packed(SceneCollection.online_lobby)
	else:
		get_tree().change_scene_to_packed(SceneCollection.offline_lobby)

func _on_go_pressed()->void:
	if SteamLobby.is_host:
		SteamLobby.random_seed=randi()
		var selected_scene:PackedScene=null
		match current_size:
			Size.S:
				selected_scene=stage_select_meta_datas[current_stage].stage_s
			Size.M:
				selected_scene=stage_select_meta_datas[current_stage].stage_m
			Size.L:
				selected_scene=stage_select_meta_datas[current_stage].stage_l
			_:
				selected_scene=null
		#change this TODO
		if selected_scene:
			get_tree().change_scene_to_packed(selected_scene)
			var msg:PackedByteArray=PackageConstructor.stage_start_up_master(0,0)
