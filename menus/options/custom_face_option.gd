extends Control
class_name CustomFaceOption 

signal custom_clicked(idx:int)
signal delete_clicked(idx:int)

@export var face_sprite:Sprite2D

var index:int=0
var current_texture:Texture2D=null

func _init(idx:int,tex:Texture2D)->void:
	index=idx
	current_texture=tex
	
	face_sprite.texture=tex
