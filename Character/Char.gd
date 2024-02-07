extends CharacterBody2D

@onready var Board=get_parent()
@onready var Exp_check=$Explosion_check
@onready var Plc_check=$Placeable_check

@onready var Face=$Face
@onready var Body=$Body
@onready var Ani=$AnimationPlayer
@onready var Blink=$Blink
@onready var i_Timer=$Timer

const movspeed=60
const max_lifes=9
const max_mul=6
const min_mul=-3
const max_power=13
const min_power=2
const max_bombs=16
const min_bombs=1

@onready var SPEED_MUL=0
@onready var CURR_BOMB=BOMBS.normal
@onready var POWER=2
@onready var ANI_SPEED=Ani.playback_speed
@onready var LIFES=1
@onready var BOMB_NUM=1
@onready var BOMB_USED=0

@export var body_type # (int, 5)
@export var body_color # (int, 31)

@export var face_type # (int, 21)
@export var face_color # (int, 31)

@onready var velocity=Vector2(0,0)
@onready var curr_ani="0"
@onready var i_frames=false


@export var blocked=true

var Action_UP ="0_Up"
var Action_DOWN ="0_Down"
var Action_LEFT ="0_Left"
var Action_RIGHT ="0_Right"
var Action_0 ="0_Action_0"
var Action_1 ="0_Action_1"

var player = 0

func set_player(idx :int):
	player=idx
	Action_UP =str(player)+"_"+"Up"
	Action_DOWN =str(player)+"_"+"Down"
	Action_LEFT =str(player)+"_"+"Left"
	Action_RIGHT =str(player)+"_"+"Right"
	Action_0 =str(player)+"_"+"Action_0"
	Action_1 =str(player)+"_"+"Action_1"

func flip(a:bool):
	Body.flip_h=a
	Face.frame=int(a)

func calculate_boost() -> float:
	if(SPEED_MUL>=0):
		return 1.0+SPEED_MUL*0.5
	else:
		return 1.0/(-1*(SPEED_MUL)+1)

func update_bomb_number():
	BOMB_USED-=1

func got_item(idx:Vector2):
	match idx:
		Vector2(0,0):
			CURR_BOMB=BOMBS.banana
		Vector2(1,0):
			CURR_BOMB=BOMBS.e
		Vector2(2,0):
			pass
		Vector2(3,0):
			pass
		Vector2(4,0):
			pass
		Vector2(5,0):
			CURR_BOMB=BOMBS.dice

		Vector2(0,1):
			pass
		Vector2(1,1):
			pass
		Vector2(2,1):
			pass
		Vector2(3,1):
			pass
		Vector2(4,1):
			pass

		Vector2(0,2):
			if(LIFES<max_lifes):
				LIFES+=1
		Vector2(1,2):
			if(POWER<max_power):
				POWER+=1
		Vector2(2,2):
			if(BOMB_NUM<max_bombs):
				BOMB_NUM+=1
		Vector2(3,2):
			if(SPEED_MUL<max_mul):
				SPEED_MUL+=1
		Vector2(4,2):
			pass

		Vector2(0,3):
			if(LIFES>0):
				LIFES-=1
		Vector2(1,3):
			if(POWER>min_power):
				POWER-=1
		Vector2(2,3):
			if(BOMB_NUM>min_bombs):
				BOMB_NUM-=1
		Vector2(3,3):
			if(SPEED_MUL>min_mul):
				SPEED_MUL-=1
		Vector2(4,3):
			pass

		Vector2(0,4):
			LIFES=max_lifes
		Vector2(1,4):
			POWER=max_power
		Vector2(2,4):
			BOMB_NUM=max_bombs
		Vector2(3,4):
			SPEED_MUL=max_mul
		Vector2(4,4):
			pass

		_:
			pass

func place_bomb():
	if (Plc_check.get_overlapping_bodies().is_empty()&&(BOMB_USED<BOMB_NUM)):
		var tmp=CURR_BOMB.instantiate()
		tmp.color=body_color
		Board.add_child(tmp)
		BOMB_USED+=1
		
		tmp.b_owner=self
		tmp.set_power(POWER)
		tmp.global_position=Board.get_board_pos(global_position)*16
		
		if(!Exp_check.get_overlapping_areas().is_empty()):
			tmp.explode()

func update_meta():
	if(LIFES>0):
		if(!Exp_check.get_overlapping_areas().is_empty()):
			if(!i_frames):
				i_Timer.start()
				LIFES-=1
				i_frames=true
				if(LIFES>=1):
					Blink.play("Blink")
	else:
		death()

func death():
	blocked=true
	Ani.playback_speed=0.7
	Ani.play("Death")

func move_loop():
	set_velocity(velocity*movspeed*calculate_boost())
	move_and_slide()

func animation_loop():
	if(velocity.x<0):
		curr_ani=curr_ani.left(1)
		flip(false)
	if(velocity.x>0):
		curr_ani=curr_ani.left(1)
		flip(true)
	if(velocity.y>0):
		curr_ani="0"
	if(velocity.y<0):
		curr_ani="1"

	if(velocity==Vector2.ZERO):
		curr_ani=curr_ani.left(1)+"_i"
	
	Ani.play(curr_ani)
	
	if(SPEED_MUL>=0):
		Ani.playback_speed=ANI_SPEED* 1+SPEED_MUL*0.5
	else:
		Ani.playback_speed=ANI_SPEED* 1/abs(SPEED_MUL)

#TODO REMOVE UICANCEL ESCAPE
func handle_input()->void:
	var tmpvel=Vector2.ZERO
	tmpvel.y += int(Input.is_action_pressed(Action_DOWN))
	tmpvel.y += -int(Input.is_action_pressed(Action_UP))
	tmpvel.x += -int(Input.is_action_pressed(Action_LEFT))
	tmpvel.x += int(Input.is_action_pressed(Action_RIGHT))
	velocity=tmpvel
	
	if Input.is_action_just_pressed(Action_0):
		place_bomb()
#	if Input.is_action_just_pressed("ui_cancel"):
#		get_tree().quit()

func _set_shader():
	#check special char
	if(body_type>2):
		Face.region_rect.position.y=28
	else:
		Face.region_rect.position.y=0
	
	Body.region_rect.position.x=body_type*18
	Face.region_rect.position.x=face_type*16
	Body.material.set_shader_parameter("Type",body_color)
	Face.material.set_shader_parameter("Type",face_color)

func _ready():
	_set_shader()

func _physics_process(delta):
	if(!blocked):
		handle_input()
		move_loop()
		animation_loop()
	update_meta()

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name=="Death"):
		get_parent().player_died()
		queue_free()

func _on_Timer_timeout():
	set_deferred("i_frames",false)
