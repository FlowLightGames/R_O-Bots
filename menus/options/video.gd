extends Control

signal cancel

var list_of_common_res:Array[Vector2i]=[
	#16:9
	Vector2i(2560,1440),
	Vector2i(1920,1080),
	Vector2i(1366,768),
	Vector2i(1280,720),
	#16:10
	Vector2i(1920,1200),
	Vector2i(1680,1050),
	Vector2i(1440,900),
	Vector2i(1280,800),
	#4:3
	Vector2i(1024,768),
	Vector2i(800,600),
	Vector2i(640,480),
	]

@export var res_label:Label
@export var CRT_check:CheckBox

var current_res_idx:int=0


func _ready()->void:
	current_res_idx=list_of_common_res.find(GameConfig.Resolution)
	if current_res_idx<0:
		current_res_idx=0
	CRT_check.button_pressed=GameConfig.CRT_Filer
	update_res_label()

func update_res_label()->void:
	res_label.text=str(list_of_common_res[current_res_idx].x)+"x"+str(list_of_common_res[current_res_idx].y)

func _on_dec_pressed()->void:
	current_res_idx=posmod(current_res_idx-1,list_of_common_res.size())
	update_res_label()

func _on_inc_pressed()->void:
	current_res_idx=posmod(current_res_idx+1,list_of_common_res.size())
	update_res_label()



func _on_save_pressed()->void:
	GameConfig.Resolution=list_of_common_res[current_res_idx]
	GameConfig.CRT_Filer=CRT_check.button_pressed
	cancel.emit()


func _on_cancel_pressed()->void:
	cancel.emit()
