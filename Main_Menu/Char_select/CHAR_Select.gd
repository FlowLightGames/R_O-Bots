extends Control

@onready var Char=$Node2D/Char
@onready var cursor=$Cursor
@onready var cursor_pos=0

@onready var pos =[
$VBoxContainer/HBoxContainer.position+$VBoxContainer.position+Vector2(-4,+6),
$VBoxContainer/HBoxContainer2.position+$VBoxContainer.position+Vector2(-4,+6),
$VBoxContainer/HBoxContainer3.position+$VBoxContainer.position+Vector2(-4,+6),
$VBoxContainer/HBoxContainer4.position+$VBoxContainer.position+Vector2(-4,+6)
]

@onready var BT=$VBoxContainer/HBoxContainer/Label
@onready var BC=$VBoxContainer/HBoxContainer2/Label
@onready var FT=$VBoxContainer/HBoxContainer3/Label
@onready var FC=$VBoxContainer/HBoxContainer4/Label

@onready var special_Char=[3,4,5]

@export var BT_V=0 # (int, 5)
@export var BC_V=0 # (int, 31)
@export var FT_V=0 # (int, 21)
@export var FC_V=0 # (int, 31)

@export var player=0 # (int, 7)

@onready var Action_UP="0_Up"
@onready var Action_DOWN="0_Down"
@onready var Action_LEFT="0_Left"
@onready var Action_RIGHT="0_Right"

func check_special():
	match BT_V:
		3:
			FT_V=0
		4:
			BC_V=31
			FT_V=1
			FC_V=31
		5:
			FT_V=21
		_:
			pass

func set_player(idx :int):
	player=idx
	Action_UP =str(player)+"_"+"Up"
	Action_DOWN =str(player)+"_"+"Down"
	Action_LEFT =str(player)+"_"+"Left"
	Action_RIGHT =str(player)+"_"+"Right"

func Update():
	BT.text=str(BT_V )
	BC.text=str(BC_V )
	FT.text=str(FT_V )
	FC.text=str(FC_V )
	Char.body_type=BT_V
	Char.body_color=BC_V
	Char.face_type=FT_V
	Char.face_color=FC_V
	
	Char._set_shader()
	
func _ready():
	cursor.position=pos[0]
	set_player(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	cursor_pos=cursor_pos+int(Input.is_action_just_pressed(Action_DOWN))-int(Input.is_action_just_pressed(Action_UP))
	cursor_pos=posmod(cursor_pos,4)
	cursor.position=pos[cursor_pos]
	match cursor_pos :
		0:
			BT_V+=int(Input.is_action_just_pressed(Action_RIGHT))-int(Input.is_action_just_pressed(Action_LEFT))
			BT_V=posmod(BT_V,6)
		1:
			BC_V+=int(Input.is_action_just_pressed(Action_RIGHT))-int(Input.is_action_just_pressed(Action_LEFT))
			BC_V=posmod(BC_V,32)
		2:
			FT_V+=int(Input.is_action_just_pressed(Action_RIGHT))-int(Input.is_action_just_pressed(Action_LEFT))
			FT_V=posmod(FT_V,22)
		3:
			FC_V+=int(Input.is_action_just_pressed(Action_RIGHT))-int(Input.is_action_just_pressed(Action_LEFT))
			FC_V=posmod(FC_V,32)
	
	check_special()
	Update()
