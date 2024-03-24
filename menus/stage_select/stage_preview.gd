extends Panel

class_name StagePreview

var pickup_ui_element:PackedScene=load("res://menus/stage_select/pickup_ui_element.tscn")

@export var tileset_preview:Control
@export var possible_spaws_grid:GridContainer
@export var spawn_percent_label:Label

@export var stage_previews:Array[PackedScene]

func _ready()->void:
	pass # Replace with function body.

func set_spawn_percent(input:float)->void:
	spawn_percent_label.text="PickUpChance: "+str(input*100.0)+"%"

func set_possible_spawn_grid(input: Array[PickUpOptionStruct])->void:
	var children:Array[Node]=possible_spaws_grid.get_children()
	for child:Node in children:
		child.queue_free()
	for n:PickUpOptionStruct in input:
		var tmp:PickUpUiElement=pickup_ui_element.instantiate()
		tmp.set_visual(n)
		possible_spaws_grid.add_child(tmp)

func set_tileset_preview(stage_num:int)->void:
	if stage_num>=0&&stage_num<stage_previews.size():
		var children:Array[Node]=tileset_preview.get_children()
		for child:Node in children:
			child.queue_free()
		var tmp:TileMap=stage_previews[stage_num].instantiate() as TileMap
		tileset_preview.add_child(tmp)
