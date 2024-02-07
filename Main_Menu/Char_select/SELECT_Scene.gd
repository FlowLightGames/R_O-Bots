extends Control

@onready var player_arr=[
$"CenterContainer/VBoxContainer/0-3/0",
$"CenterContainer/VBoxContainer/0-3/1",
$"CenterContainer/VBoxContainer/0-3/2",
$"CenterContainer/VBoxContainer/0-3/3",
$"CenterContainer/VBoxContainer/4-7/4",
$"CenterContainer/VBoxContainer/4-7/5",
$"CenterContainer/VBoxContainer/4-7/6",
$"CenterContainer/VBoxContainer/4-7/7"]

func _ready():
	for n in 7-LOCAL_MULTI.number_player:
		player_arr[7-n].queue_free()
		player_arr.remove(7-n)
	
	for i in LOCAL_MULTI.players:
		i.queue_free()
	
	LOCAL_MULTI.players.clear()
	
	set_physics_process(false)

func check_input():
	if Input.is_action_just_pressed("ui_accept"):
		for i in player_arr:
			LOCAL_MULTI.players.append(i.Char.duplicate())
		GLOBALS.change_level("res://Main_Menu/Stage_select/STAGE_Select.tscn")
	
	if Input.is_action_just_pressed("ui_cancel"):
		GLOBALS.change_level("res://Main_Menu/Player_select/NUMBER_Select.tscn")

func _physics_process(delta):
	check_input()


func _on_Timer_timeout():
	set_physics_process(true)
