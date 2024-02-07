extends Node2D

@onready var cursor=$Cursor
@onready var cursor_pos=0

@onready var pos =[
$CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/TextureRect.global_position-Vector2(14,0),
$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/TextureRect.global_position-Vector2(14,0),
$CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/TextureRect.global_position-Vector2(14,0)
]


@onready var Action_UP="0_Up"
@onready var Action_DOWN="0_Down"
#onready var Action_LEFT="0_Left"
#onready var Action_RIGHT="0_Right"

func _ready():
	cursor.global_position=pos[0]

func check_input():
	if Input.is_action_just_pressed(Action_DOWN):
		cursor_pos=posmod(cursor_pos+1,3)
		cursor.global_position=pos[cursor_pos]
	if Input.is_action_just_pressed(Action_UP):
		cursor_pos=posmod(cursor_pos-1,3)
		cursor.global_position=pos[cursor_pos]
	if Input.is_action_just_pressed("ui_accept"):
		match cursor_pos :
			0:
				pass
			1:
				GLOBALS.change_level("res://Main_Menu/Player_select/NUMBER_Select.tscn")
			2:
				GLOBALS.set_crt(!GLOBALS.get_crt())
			_:
				pass

func _process(delta):
	check_input()
