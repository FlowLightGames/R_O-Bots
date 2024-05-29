extends Node2D
class_name MapBase
var player_scene:PackedScene=load("res://player_character/character.tscn")
var pickup_scene:PackedScene=load("res://pickup/pickup.tscn")
var bomb_out_of_bound_scene:PackedScene=load("res://bombs/bomb_out_of_bound_anim.tscn")
var draw_overlay:PackedScene=load("res://maps/UI/draw.tscn")
var win_overlay:PackedScene=load("res://maps/UI/CRT_Win_Screen.tscn")
var countdown_overlay:PackedScene=load("res://maps/UI/countdown.tscn")

@export var spawnpoint_tilemap:TileMap
@export var base_ground_tilemap:TileMap
@export var statics_tilemap:TileMap
@export var destroyables_random_spawner:DestroyablesRandomSpawner
@export var camera:Camera2D
@export var stage_ui:StageUI
@export var player_nodes:Node2D
@export var bomb_nodes:Node2D
@export var enemy_nodes:Node2D
@export var possible_pickups:PickUpMap

@export var round_time:float=180.0
@export var round_timer:Timer

var disabled:bool=false
var player_ref_list:Array[PlayerCharacter]=[]
var destroyables_ref_dict:Dictionary={}

func _ready()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		seed(SteamLobby.random_seed)
	else:
		randomize()
	spawn_players(MultiplayerStatus.Current_Number_Of_Players)
	round_timer.wait_time=round_time
	stage_ui.initial_time(round_time)
	var tmp_countdown:Countdown=countdown_overlay.instantiate() as Countdown
	tmp_countdown.map=self
	add_child(tmp_countdown)
	
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		PackageDeconstructor.player_state_update.connect(on_player_state_update_recieved)
		PackageDeconstructor.game_state_update.connect(on_game_state_update_recieved)
		PackageDeconstructor.round_end.connect(on_round_end_recieved)
		MultiplayerStatus.Current_Loaded_Map=self
		MultiplayerStatus.start_timer()

#for multiplayer
func on_player_state_update_recieved(who_steam_id:int,elapsed_time:int,player_state:PlayerState)->void:
	print("got playerstate")
	var config_idx:int=PlayerConfigs.get_player_index_by_steam_id(who_steam_id)
	#check if info is correct
	if config_idx in range(0,PlayerConfigs.Player_Configs.size())&&player_state.player_number==config_idx:
		#check if info still relevant aka if udp is out of order:
		if PlayerConfigs.Player_Configs[config_idx].elapsed_time<elapsed_time:
			#update elapsed time
			PlayerConfigs.set_elapsed_time(config_idx,elapsed_time)
			var player:PlayerCharacter=get_player_by_number(player_state.player_number)
			if player:
				player.apply_player_state(player_state)

func on_game_state_update_recieved(who_steam_id:int,elapsed_time:int,game_state:GameState)->void:
	print("got GAMESTATE")
	var tmp_alives:Array[PlayerState]=game_state.alive_players.duplicate()
	for n:PlayerState in tmp_alives:
		var pn:int=n.player_number
		var player:PlayerCharacter=get_player_by_number(pn)
		if player:
			player.apply_player_state(n)
			tmp_alives.erase(n)
	#revive if the shoudld be any unjust deaths
	for n:PlayerState in tmp_alives:
		var character:PlayerCharacter=player_scene.instantiate() as PlayerCharacter
		character.Player_Number=n.player_number
		player_nodes.add_child(character)
		character.set_player_name(Steam.getFriendPersonaName(PlayerConfigs.Player_Configs[n.player_number].steam_id))
		if n.player_number!=SteamLobby.player_number:
			character.is_puppet=true
		character.config_init(PlayerConfigs.Player_Configs[n.player_number])
		character.input_map_init()
		character.position=Vector2i(1024,1024)
		character.map=self
		character.disabled=false
		player_ref_list.append(character)
		stage_ui.update_icons(player_ref_list)
	#for n:PlayerCharacter in player_ref_list:
		#var p:PlayerState=null
		#for ps in tmp_alives
		#if !(n.Player_Number in game_state.alive_players):
			#n.die()
		#else:
			#tmp_alives.erase(n.Player_Number)
	#revive if the shoudld be any unjust deaths
	#for n:PlayerState in tmp_alives:
		#var character:PlayerCharacter=player_scene.instantiate() as PlayerCharacter
		#character.Player_Number=n
		#player_nodes.add_child(character)
		#character.set_player_name(Steam.getFriendPersonaName(PlayerConfigs.Player_Configs[n].steam_id))
		#if !(n==SteamLobby.player_number):
			#character.is_puppet=true
		#character.config_init(PlayerConfigs.Player_Configs[n])
		#character.input_map_init()
		#character.position=Vector2i(1024,1024)
		#character.map=self
		#character.disabled=false
		#player_ref_list.append(character)
		#stage_ui.update_icons(player_ref_list)
	#handlebricks 
	var tmp_destroy_ref:Dictionary=destroyables_ref_dict.duplicate()
	for n:Vector2i in tmp_destroy_ref:
		if !(game_state.destroyables_list.has(n)):
			if!(tmp_destroy_ref[n] as BrickBase).currently_being_destroyed:
				(tmp_destroy_ref[n] as BrickBase).spawn_pickup_and_free()
				tmp_destroy_ref.erase(n)
	for n:Vector2i in tmp_destroy_ref:
		destroyables_random_spawner.spawn_block(n)

func on_round_end_recieved(who_steam_id:int,elapsed_time:int,winner_num:int)->void:
	if winner_num<0:
		draw()
	elif winner_num in range(0,8):
		win(winner_num)

func pick_up_with_weights(rng:RandomNumberGenerator)->PickUpOptionStruct:
	if !possible_pickups.map.is_empty():
		var total_weight:int=0
		for i:PickUpOptionStruct in possible_pickups.map:
			total_weight+=i.weight
		var random_num:int=rng.randi()%total_weight
		
		var cumulative_weight:int=0
		for p:PickUpOptionStruct in possible_pickups.map:
			cumulative_weight+= p.weight
			if random_num<cumulative_weight:
				return p
	return null

func draw()->void:
	disabled=true
	round_timer.stop()
	for n:PlayerCharacter in player_ref_list:
		n.disable()
	var tmp:DrawOverlay=draw_overlay.instantiate() as DrawOverlay
	send_round_end(-1)
	add_child(tmp)

func win(player:int)->void:
	disabled=true
	round_timer.stop()
	for n:PlayerCharacter in player_ref_list:
		n.disable()
	var tmp:WinOverlay=win_overlay.instantiate() as WinOverlay
	tmp.old_cam=camera
	tmp.set_winner(PlayerConfigs.Player_Configs[player])
	send_round_end(player)
	add_child(tmp)

func send_round_end(winner_num:int)->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		if SteamLobby.is_host:
			var msg:PackedByteArray=PackageConstructor.round_end(winner_num,GlobalSteam.steam_id)
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,msg)

func check_winner()->void:
	if !disabled:
		if player_ref_list.size()>0:
			if player_ref_list.size()==1:
				if player_ref_list[0].BodyAnimation.current_animation=="death":
					draw()
				else:
					win(player_ref_list[0].Player_Number)
		else:
			draw()

func time_out()->void:
	if !disabled:
		for n:PlayerCharacter in player_ref_list:
			n.disable()
		if player_ref_list.size()>0:
			if player_ref_list.size()==1:
				if player_ref_list[0].BodyAnimation.current_animation=="death":
					draw()
				else:
					win(player_ref_list[0].Player_Number)
			else:
				draw()
		else:
			draw()
	disabled=true

func spawn_players(how_many:int)->void:
	var possible_spawns:Array[Vector2i]=spawnpoint_tilemap.get_used_cells(0)
	if how_many>=1&&how_many<=possible_spawns.size():
		for n:int in range(0,how_many):
			var spawn:Vector2i=possible_spawns.pick_random()
			var character:PlayerCharacter=player_scene.instantiate() as PlayerCharacter
			#imprtant to set first
			character.Player_Number=n
			player_nodes.add_child(character)
			
			
			if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
				character.set_player_name(Steam.getFriendPersonaName(PlayerConfigs.Player_Configs[n].steam_id))
				if !(n==SteamLobby.player_number):
					character.is_puppet=true
			else:
				character.set_player_name("Player"+str(n))
			character.config_init(PlayerConfigs.Player_Configs[n])
			character.input_map_init()
			character.position=spawn*16+Vector2i(8,8)
			character.map=self
			character.disabled=true
			player_ref_list.append(character)
			possible_spawns.erase(spawn)
		stage_ui.update_icons(player_ref_list)
	spawnpoint_tilemap.visible=false

func unlock_players()->void:
	for n:PlayerCharacter in player_ref_list:
		n.enable()
	round_timer.start()
	stage_ui.start()

func _on_round_timer_timeout()->void:
	time_out()

func get_gamestate()->GameState:
	var output:GameState=GameState.new()
	var alive_players:Array[PlayerState]=[]
	for n:PlayerCharacter in player_ref_list:
		alive_players.append(n.get_player_state())
	output.alive_players=alive_players
	var destroyables:Array[Vector2i]=[]
	for n:Vector2i in destroyables_ref_dict:
		destroyables.append(n)
	output.destroyables_list=destroyables
	return output

func get_player_state(player_num:int)->PlayerState:
	var player:PlayerCharacter=get_player_by_number(player_num)
	if player:
		return player.get_player_state()
	else:
		#player is dead
		var output:PlayerState=PlayerState.new()
		output.dead=true
		output.player_number=player_num
		return output

func get_player_by_number(player_num:int)->PlayerCharacter:
	for n:PlayerCharacter in player_ref_list:
		if n.Player_Number==player_num:
			return n
	return null

func get_playerstate(player_num:int)->PlayerState:
	var player:PlayerCharacter=get_player_by_number(player_num)
	#player is alive
	if player:
		return player.get_player_state()
	#player is dead
	else:
		var output:PlayerState=PlayerState.new()
		output.player_number=player_num
		output.dead=true
		return output

func _on_out_of_bound_body_entered(body:Node2D)->void:
	if body is BombBase:
		#spawn glitch
		var tmp:Sprite2D=bomb_out_of_bound_scene.instantiate() as Sprite2D
		bomb_nodes.add_child(tmp)
		tmp.global_position=body.global_position
		if is_instance_valid((body as BombBase).affiliated_player):
			(body as BombBase).affiliated_player.Bomb_Ref_List.erase(body)
		body.queue_free()
