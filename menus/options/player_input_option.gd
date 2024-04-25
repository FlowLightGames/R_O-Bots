extends PanelContainer
class_name PlayerInputOption

signal pressed(player_num:int)

@export var player_num:int=0
@export var player_num_label:Label

func _ready()->void:
	player_num_label.text="PLR_"+str(player_num)

func _on_customize_pressed()->void:
	pressed.emit(player_num)
