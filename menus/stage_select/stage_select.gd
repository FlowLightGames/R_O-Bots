extends Node2D

@export var stage_label:Label
@export var size_label:Label
@export var stage_preview:StagePreview
@export var stage_select_meta_datas:Array[StageSelectMetaData]

@export var multiplayer_exlusive_nodes:Array[Node]

enum SIZE {
	S,M,L
}

var max_sizes:int=3
var max_stages:int=0

var current_size:SIZE=SIZE.M
var current_stage:int=0

func _ready()->void:
	
	for n:StageSelectMetaData in stage_select_meta_datas:
		n.stage_pickup_map.sort_map()
	max_stages=stage_select_meta_datas.size()
	current_size=SIZE.M
	current_stage=0
	apply_new_selection()
	
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_LOBBY:
		PackageDeconstructor.stage_selected.connect(_on_stage_start_recieved)
	else:
		for n:Node in multiplayer_exlusive_nodes:
			n.free()
	



func apply_new_selection()->void:
	size_label.text=SIZE.keys()[current_size]
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
	#TODO way more logic for host and infrom clients?
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		get_tree().change_scene_to_packed(SceneCollection.online_lobby)
	else:
		get_tree().change_scene_to_packed(SceneCollection.offline_lobby)

func get_map_scene(index:int,size:SIZE)->PackedScene:
	var selected_scene:PackedScene=null
	if index in range(0,stage_select_meta_datas.size()):
		match current_size:
			SIZE.S:
				selected_scene=stage_select_meta_datas[index].stage_s
			SIZE.M:
				selected_scene=stage_select_meta_datas[index].stage_m
			SIZE.L:
				selected_scene=stage_select_meta_datas[index].stage_l
			_:
				selected_scene=null
	return selected_scene

func _on_go_pressed()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_LOBBY:
		if SteamLobby.is_host:
			SteamLobby.random_seed=randi()
			var selected_scene:PackedScene=get_map_scene(current_stage,current_size)
			if selected_scene:
				for n:int in range(1,MultiplayerStatus.Current_Number_Of_Players):
					var msg:PackedByteArray=PackageConstructor.stage_start_up_master(SteamLobby.random_seed,
					PlayerConfigs.Player_Configs[n].message_delay_tcp,
					current_stage,
					int(current_size))
					SteamLobby.send_p2p_packet(PlayerConfigs.Player_Configs[n].steam_id,Steam.P2P_SEND_RELIABLE,msg)
				var stage:PackedScene=load("res://maps/instances/default_M.tscn") as PackedScene
				MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_MULTIPLAYER
				get_tree().change_scene_to_packed(selected_scene)
	else:
		var selected_scene:PackedScene=get_map_scene(current_stage,current_size)
		if selected_scene:
			get_tree().change_scene_to_packed(selected_scene)

func _on_stage_start_recieved(seed:int,package_delay:int,stage_index:int,stage_size:int)->void:
	SteamLobby.random_seed=seed
	MultiplayerStatus.Current_Status=MultiplayerStatus.STATE.ONLINE_MULTIPLAYER
	MultiplayerStatus.Delay_To_Host_TCP=package_delay
	var map:PackedScene=get_map_scene(stage_index,stage_size as SIZE)
	if map:
		get_tree().change_scene_to_packed(map)
	else:
		get_tree().change_scene_to_packed(SceneCollection.main_menu)
	
