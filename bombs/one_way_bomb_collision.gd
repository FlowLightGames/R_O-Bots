extends StaticBody2D
class_name OneWayCollision

var toggled_on:bool=true
var col_layer_toggle_buffer:int=0
var col_mask_toggle_buffer:int=0

func toggle_collision()->void:
	if toggled_on:
		col_mask_toggle_buffer=collision_mask
		col_layer_toggle_buffer=collision_layer
		collision_layer=0
		collision_mask=0
		toggled_on=false
	else:
		collision_layer=col_layer_toggle_buffer
		collision_mask=col_mask_toggle_buffer
		toggled_on=true
#@export var bomb_body:CharacterBody2D
