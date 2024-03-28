extends Control

class_name PickUpUiElement
@export var sprite:Sprite2D

func set_visual(input: PickUpOptionStruct)->void:
	sprite.frame_coords=PickUp.get_item_index(input.what)
