extends Node2D

@onready var board=$Floor
@onready var spawner=$Player_Spawners.get_children()
@onready var win_ui=$Node2D/CenterContainer/Label
@onready var win_part=$Node2D/GPUParticles2D
@onready var win_timer=$Node2D/Timer

@export (bool) var random_spawn=false
@export (Array , int) var PU_bomb
@export (Array , int) var PU_ability
@export (Array , int) var PU_plus
@export (Array , int) var PU_minus
@export (Array , int) var PU_max
@export (Array , int) var PU_special

@export(int)var bomb_weight
@export(int)var ability_weight
@export(int)var plus_weight
@export(int)var minus_weight
@export(int)var max_weight
@export(int)var special_weight

func get_board_pos(vec :Vector2):
	return board.local_to_map(vec)

func get_random_item()->Vector2:
	
	var tmp=posmod(randi(),100)
	
	if(tmp<bomb_weight):
		return Vector2(PU_bomb[posmod(randi(),PU_bomb.size())],0)
	elif(tmp<bomb_weight+ability_weight):
		return Vector2(PU_ability[posmod(randi(),PU_ability.size())],1)
	elif(tmp<bomb_weight+ability_weight+plus_weight):
		return Vector2(PU_plus[posmod(randi(),PU_plus.size())],2)
	elif(tmp<bomb_weight+ability_weight+plus_weight+minus_weight):
		return Vector2(PU_minus[posmod(randi(),PU_minus.size())],3)
	elif(tmp<bomb_weight+ability_weight+plus_weight+minus_weight+max_weight):
		return Vector2(PU_max[posmod(randi(),PU_max.size())],4)
	else:
		return Vector2(PU_special[posmod(randi(),PU_special.size())],5)

func player_died():
	var tmp=get_tree().get_nodes_in_group("Player")
	var winner=null
	for i in tmp:
		if (i.LIFES>0):
			if(winner==null):
				winner=i
			else:
				return
	if(winner==null):
		win_ui.text="NOONE WON"
		win_ui.visible=true
		win_part.emitting=true
		win_timer.start()

	else:
		win_ui.text="PLAYER "+str(winner.player+1)+" WON"
		win_ui.visible=true
		win_part.emitting=true
		win_timer.start()

func _ready():
	if(random_spawn):
		spawner.shuffle()
	for i in LOCAL_MULTI.number_player+1:
		var tmp=LOCAL_MULTI.players[i].duplicate()
		tmp.position=spawner[i].position
		add_child(tmp)
		tmp.set_player(i)
		tmp.blocked=false

#func _process(delta):
#	pass


func _on_Timer_timeout():
	GLOBALS.change_level("res://Main_Menu/Stage_select/STAGE_Select.tscn")
