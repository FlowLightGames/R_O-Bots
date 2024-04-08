extends Node2D
class_name MapBase
var player_scene:PackedScene=load("res://player_character/character.tscn")
var pickup_scene:PackedScene=load("res://pickup/pickup.tscn")
var draw_overlay:PackedScene=load("res://maps/UI/draw.tscn")
var win_overlay:PackedScene=load("res://maps/UI/CRT_Win_Screen.tscn")
var countdown_overlay:PackedScene=load("res://maps/UI/countdown.tscn")

@export var players_spawned:int=4
@export var spawnpoint_tilemap:TileMap
@export var base_ground_tilemap:TileMap
@export var camera:Camera2D
@export var time_ui:StageUI
@export var player_nodes:Node2D
@export var bomb_nodes:Node2D
@export var enemy_nodes:Node2D

@export var possible_pickups:PickUpMap

@export var round_time:float=180.0
@export var round_timer:Timer

var disabled:bool=false
var player_ref_list:Array[PlayerCharacter]=[]

func pick_up_with_weights()->PickUpOptionStruct:
	if !possible_pickups.map.is_empty():
		var total_weight:int=0
		for i:PickUpOptionStruct in possible_pickups.map:
			total_weight+=i.weight
		var random_num:int=randi()%total_weight
		
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
		n.disabled=true
	var tmp:DrawOverlay=draw_overlay.instantiate() as DrawOverlay
	add_child(tmp)

func win(player:int)->void:
	disabled=true
	round_timer.stop()
	for n:PlayerCharacter in player_ref_list:
		n.disabled=true
	var tmp:WinOverlay=win_overlay.instantiate() as WinOverlay
	tmp.old_cam=camera
	tmp.set_winner(PlayerConfigs.Player_Configs[player])
	add_child(tmp)

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
			n.disabled=true
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
			player_nodes.add_child(character)
			character.Player_Number=n
			character.config_init(PlayerConfigs.Player_Configs[n])
			character.position=spawn*16+Vector2i(8,8)
			character.map=self
			character.disabled=true
			player_ref_list.append(character)
			possible_spawns.erase(spawn)
	spawnpoint_tilemap.visible=false

func unlock_players()->void:
	for n:PlayerCharacter in player_ref_list:
		n.disabled=false
	round_timer.start()
	time_ui.start()

func _ready()->void:
	spawn_players(players_spawned)
	round_timer.wait_time=round_time
	time_ui.initial_time(round_time)
	var tmp_countdown:Countdown=countdown_overlay.instantiate() as Countdown
	tmp_countdown.map=self
	add_child(tmp_countdown)

func _on_round_timer_timeout()->void:
	time_out()

func get_gamestate()->GameState:
	var output:GameState=GameState.new()
	return output
