extends Node2D

const max_stages=2

@onready var cursor=$Cursor
@onready var cursor_pos=0

@onready var Action_UP="0_Up"
@onready var Action_DOWN="0_Down"
@onready var Action_LEFT="0_Left"
@onready var Action_RIGHT="0_Right"

@onready var PN=$CenterContainer/VBoxContainer/HBoxContainer/Label

@onready var pos =[
$CenterContainer/VBoxContainer/HBoxContainer.global_position-Vector2(14,0)
]

func _ready():
	cursor.global_position=pos[0]
	LOCAL_MULTI.curr_stage=0
	PN.text=str(LOCAL_MULTI.curr_stage+1)
	set_process(false)

func check_input():
	if Input.is_action_just_pressed("ui_accept"):
		GLOBALS.change_level("res://Stages/Levels/_"+ str(LOCAL_MULTI.curr_stage) + ".tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		GLOBALS.change_level("res://Main_Menu/Char_select/SELECT_Scene.tscn")

func _process(delta):
#	cursor_pos=cursor_pos+int(Input.is_action_just_pressed(Action_DOWN))-int(Input.is_action_just_pressed(Action_UP))
#	cursor_pos=posmod(cursor_pos,4)
#	cursor.rect_position=pos[cursor_pos]
	
	match cursor_pos :
		0:
			LOCAL_MULTI.curr_stage+=int(Input.is_action_just_pressed(Action_RIGHT))-int(Input.is_action_just_pressed(Action_LEFT))
			LOCAL_MULTI.curr_stage=posmod(LOCAL_MULTI.curr_stage,max_stages)
			PN.text=str(LOCAL_MULTI.curr_stage+1)
		_:
			pass
	check_input()


func _on_Timer_timeout():
	set_process(true)
