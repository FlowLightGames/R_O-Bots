extends Node2D

var start_pos:Vector2=Vector2.ZERO
var global_start_pos:Vector2=Vector2.ZERO
@export var body_base:Sprite2D

var time_elapsed:float=0.0
var x_amp:float=16.0
var y_amp:float=8.0
var y_speed:float=2.0
var x_speed:float=2.0

func _ready()->void:
	start_pos=body_base.position
	global_start_pos=body_base.global_position
	x_speed*=global_start_pos.y/360.0
	y_speed*=global_start_pos.y/360.0
	#var rand:int=posmod(int(position.x*0.33+position.y*2.0),12)

func _process(delta:float)->void:
	time_elapsed+=delta
	
	body_base.position.y=start_pos.y+sin(time_elapsed*y_speed+global_start_pos.y)*y_amp
	#body_base.position.x=start_pos.x+sin(time_elapsed*x_speed+global_start_pos.x)*x_amp
	
	if time_elapsed>=120.0:
		time_elapsed-=120.0
