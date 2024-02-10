extends CanvasLayer
class_name Countdown
@export var wordart_sprite:Sprite2D
@export var map:MapBase

var regions:Array[Rect2i]=[Rect2i(Vector2i(16,0),Vector2i(96,176)),Rect2i(Vector2i(128,0),Vector2i(96,176)),Rect2i(Vector2i(240,0),Vector2i(96,176)),Rect2i(Vector2i(352,0),Vector2i(208,176))]

func unlock_players()->void:
	map.unlock_players()
func set_region(to:int)->void:
	wordart_sprite.region_rect=regions[to]
