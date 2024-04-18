extends Resource

class_name PickUpStats

#CAN only have one
enum SPECIALSTATE{
	NONE,GUN,KNIFE,ZEUS
}

#Can have multiple
enum STATE{
	POOP,FIRE,FART
}

var BOMB_TYPE:BombList.BOMBTYPE=BombList.BOMBTYPE.DEFAULT
var SPEED_UP:int=0
var BOMB_UP:int=0
var FIRE_UP:int=0
var LIFE_UP:int=0
var KICKER:bool=false
var DUNKER:bool=false
var BRICK_WALKER:bool=false
var SPECIAL_STATE:SPECIALSTATE=SPECIALSTATE.NONE
#MAP
#0: POOP
#1: FIRE
#2: FART
var STATES:Array[int]=[0,0,0]

func get_speed_scale()->float:
	## max speed scale 6 min speedscale 0.5
	match SPEED_UP:
		-10:
			return 0.50
		-9:
			return 0.55
		-8:
			return 0.60
		-7:
			return 0.65
		-6:
			return 0.70
		-5:
			return 0.75
		-4:
			return 0.80
		-3:
			return 0.85
		-2:
			return 0.90
		-1:
			return 0.95
		0:
			return 1.0
		1:
			return 1.5
		2:
			return 2.0
		3:
			return 2.5
		4:
			return 3.0
		5:
			return 3.5
		6:
			return 4.0
		7:
			return 4.5
		8:
			return 5.0
		9:
			return 5.5
		10:
			return 6.0
		_:
			return 1.0

func _init(speedup:int=0,bombup:int=0,fireup:int=0,lifeup:int=0,kicker:bool=false,dunker:bool=false,specialstate:SPECIALSTATE=SPECIALSTATE.NONE)->void:
	SPEED_UP=speedup
	BOMB_UP=bombup
	FIRE_UP=fireup
	LIFE_UP=lifeup
	KICKER=kicker
	DUNKER=dunker
	SPECIAL_STATE=specialstate

func add_state(state:STATE)->void:
	match state:
		STATE.POOP:
			STATES[0]+=1
		STATE.FIRE:
			STATES[1]+=1
		STATE.FART:
			STATES[2]+=1
		_:
			pass

func clamp_stats()->void:
	SPEED_UP=clampi(SPEED_UP,-10,10)
	BOMB_UP=clampi(BOMB_UP,0,16)
	FIRE_UP=clampi(FIRE_UP,0,10)
	LIFE_UP=clampi(LIFE_UP,-1,10)
