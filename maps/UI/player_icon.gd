extends Control

class_name PlayerIcon

@export var name_label:Label
@export var lifes_label:Label
@export var icon_sprite:Sprite2D
@export var number:int=0

func _ready()->void:
	(icon_sprite.material as ShaderMaterial).set_shader_parameter("Type",number)

func set_player_name(name:String)->void:
	name_label.text=name

func update_state(lives:int)->void:
	if lives >=0:
		lifes_label.text=str(min(lives,99))
		icon_sprite.frame=0
	else:
		lifes_label.text=""
		icon_sprite.frame=1
