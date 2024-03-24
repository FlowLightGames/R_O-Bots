extends Control

class_name PickUpUiElement
@export var sprite:Sprite2D

func set_visual(input: PickUpOptionStruct)->void:
	match input.what:
		##BOMBS##
		PickUp.PICKUP.BANANA:
			sprite.frame_coords=Vector2i(0,0)
		PickUp.PICKUP.E:
			sprite.frame_coords=Vector2i(1,0)
		PickUp.PICKUP.REMOTE:
			sprite.frame_coords=Vector2i(2,0)
		PickUp.PICKUP.MINE:
			sprite.frame_coords=Vector2i(3,0)
		PickUp.PICKUP.DICE:
			sprite.frame_coords=Vector2i(4,0)
		PickUp.PICKUP.PLASMA:
			sprite.frame_coords=Vector2i(5,0)
		##STATS
		PickUp.PICKUP.LIFE_UP:
			sprite.frame_coords=Vector2i(0,1)
		PickUp.PICKUP.FIRE_UP:
			sprite.frame_coords=Vector2i(1,1)
		PickUp.PICKUP.BOMB_UP:
			sprite.frame_coords=Vector2i(2,1)
		PickUp.PICKUP.SPEED_UP:
			sprite.frame_coords=Vector2i(3,1)
		##STATS DOWN##
		PickUp.PICKUP.LIFE_DOWN:
			sprite.frame_coords=Vector2i(0,2)
		PickUp.PICKUP.FIRE_DOWN:
			sprite.frame_coords=Vector2i(1,2)
		PickUp.PICKUP.BOMB_DOWN:
			sprite.frame_coords=Vector2i(2,2)
		PickUp.PICKUP.SPEED_DOWN:
			sprite.frame_coords=Vector2i(3,2)
		##STATS MAX##
		PickUp.PICKUP.LIFE_MAX:
			sprite.frame_coords=Vector2i(0,3)
		PickUp.PICKUP.FIRE_MAX:
			sprite.frame_coords=Vector2i(1,3)
		PickUp.PICKUP.BOMB_MAX:
			sprite.frame_coords=Vector2i(2,3)
		PickUp.PICKUP.SPEED_MAX:
			sprite.frame_coords=Vector2i(3,3)
		##BALLS##
		PickUp.PICKUP.KICKER:
			sprite.frame_coords=Vector2i(0,4)
		PickUp.PICKUP.DUNKER:
			sprite.frame_coords=Vector2i(1,4)
		#UNDECIDED
		PickUp.PICKUP.BRICK_WALKER:
			sprite.frame_coords=Vector2i(0,5)
		PickUp.PICKUP.UNDECIDED_1:
			sprite.frame_coords=Vector2i(1,5)
		#KIFEGUN
		PickUp.PICKUP.KNIFE:
			sprite.frame_coords=Vector2i(0,6)
		PickUp.PICKUP.GUN:
			sprite.frame_coords=Vector2i(1,6)
