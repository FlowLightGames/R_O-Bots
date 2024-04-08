extends Control
class_name StageUI

@export var timer:Timer

@export var minutes_0:Sprite2D
@export var minutes_1:Sprite2D

@export var seconds_0:Sprite2D
@export var seconds_1:Sprite2D

@export var centiseconds_0:Sprite2D
@export var centiseconds_1:Sprite2D

func initial_time(round_time:float)->void:
	var minutes_left:int=int(round_time/60.0)
	var seconds_left:int=int(round_time-float(minutes_left*60))
	#var centiseconds_left:int=roundi(fposmod(timer.time_left,float(minutes_left*60+seconds_left))*10.0)
	var centiseconds_left:int=posmod(roundi(round_time*10.0),10)
	
	
	minutes_0.frame=minutes_left/10
	minutes_1.frame=posmod(minutes_left,10)
	
	seconds_0.frame=seconds_left/10
	seconds_1.frame=posmod(seconds_left,10)
	
	centiseconds_0.frame=mini(centiseconds_left,9)
	#centiseconds_1.frame=posmod(centiseconds_left,10)

func _ready()->void:
	set_physics_process(false)

func start()->void:
	set_physics_process(true)

func _physics_process(_delta:float)->void:
	var minutes_left:int=int(timer.time_left/60.0)
	var seconds_left:int=int(timer.time_left-float(minutes_left*60))
	#var centiseconds_left:int=roundi(fposmod(timer.time_left,float(minutes_left*60+seconds_left))*10.0)
	var centiseconds_left:int=posmod(roundi(timer.time_left*10.0),10)
	
	
	minutes_0.frame=minutes_left/10
	minutes_1.frame=posmod(minutes_left,10)
	
	seconds_0.frame=seconds_left/10
	seconds_1.frame=posmod(seconds_left,10)
	
	centiseconds_0.frame=mini(centiseconds_left,9)
	#centiseconds_1.frame=posmod(centiseconds_left,10)
