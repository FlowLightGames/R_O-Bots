extends Area2D

class_name PickUp

enum PICKUP{
	BANANA,E,REMOTE,MINE,DICE,PLASMA,HYDROGEN,
	LIFE_UP,FIRE_UP,BOMB_UP,SPEED_UP,
	LIFE_DOWN,FIRE_DOWN,BOMB_DOWN,SPEED_DOWN,
	LIFE_MAX,FIRE_MAX,BOMB_MAX,SPEED_MAX,
	KICKER,DUNKER,
	BRICK_WALKER,UNDECIDED_1,
	KNIFE,GUN
}

@export var type:PICKUP
@export var sprite:Sprite2D

var disabled:bool=false

func set_sprite(what:PICKUP)->void:
	sprite.frame_coords=get_item_index(what)

static func get_item_index(what:PICKUP)->Vector2i:
	match what:
		##BOMBS##
		PICKUP.BANANA:
			return Vector2i(0,0)
		PICKUP.E:
			return Vector2i(1,0)
		PICKUP.REMOTE:
			return Vector2i(2,0)
		PICKUP.MINE:
			return Vector2i(3,0)
		PICKUP.DICE:
			return Vector2i(4,0)
		PICKUP.PLASMA:
			return Vector2i(5,0)
		PICKUP.HYDROGEN:
			return Vector2i(6,0)
		##STATS
		PICKUP.LIFE_UP:
			return Vector2i(0,1)
		PICKUP.FIRE_UP:
			return Vector2i(1,1)
		PICKUP.BOMB_UP:
			return Vector2i(2,1)
		PICKUP.SPEED_UP:
			return Vector2i(3,1)
		##STATS DOWN##
		PICKUP.LIFE_DOWN:
			return Vector2i(0,2)
		PICKUP.FIRE_DOWN:
			return Vector2i(1,2)
		PICKUP.BOMB_DOWN:
			return Vector2i(2,2)
		PICKUP.SPEED_DOWN:
			return Vector2i(3,2)
		##STATS MAX##
		PICKUP.LIFE_MAX:
			return Vector2i(0,3)
		PICKUP.FIRE_MAX:
			return Vector2i(1,3)
		PICKUP.BOMB_MAX:
			return Vector2i(2,3)
		PICKUP.SPEED_MAX:
			return Vector2i(3,3)
		##BALLS##
		PICKUP.KICKER:
			return Vector2i(0,4)
		PICKUP.DUNKER:
			return Vector2i(1,4)
		#UNDECIDED
		PICKUP.BRICK_WALKER:
			return Vector2i(0,5)
		PICKUP.UNDECIDED_1:
			return Vector2i(1,5)
		#KIFEGUN
		PICKUP.KNIFE:
			return Vector2i(0,6)
		PICKUP.GUN:
			return Vector2i(1,6)
		_:
			return Vector2i(0,0)

func destroy()->void:
	disabled=true
	queue_free()

func _ready()->void:
	set_sprite(type)


func _on_body_entered(body:Node2D)->void:
	if body is PlayerCharacter:
		if(!disabled):
			(body as PlayerCharacter).picked_up(type)
			queue_free()
