extends Control
class_name CustomFaceOption 

signal custom_clicked(idx:int)
signal delete_clicked(idx:int)

@export var face_sprite:Sprite2D

var index:int=0
var current_texture:Texture2D=null

func set_texture(tex:Texture2D)->void:
	current_texture=tex
	face_sprite.texture=tex

func set_init(idx:int,tex:Texture2D)->void:
	index=idx
	current_texture=tex
	face_sprite.texture=tex


func _on_cstmz_pressed()->void:
	custom_clicked.emit(index)


func _on_dlt_pressed()->void:
	delete_clicked.emit(index)
