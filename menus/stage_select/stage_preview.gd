extends Control

class_name StagePreview

var pickup_ui_element:PackedScene=load("res://menus/stage_select/pickup_ui_element.tscn")

@export var tileset_preview:Control
@export var possible_spaws_grid:GridContainer
@export var spawn_percent_label:Label


func set_spawn_percent(input:float)->void:
	spawn_percent_label.text="PickUpChance: "+str(int(input*100.0))+"%"

func set_possible_spawn_grid(input: Array[PickUpOptionStruct])->void:
	var children:Array[Node]=possible_spaws_grid.get_children()
	for child:Node in children:
		child.queue_free()
	for n:PickUpOptionStruct in input:
		var tmp:PickUpUiElement=pickup_ui_element.instantiate()
		tmp.set_visual(n)
		possible_spaws_grid.add_child(tmp)

func set_tileset_preview(input: StageSelectMetaData)->void:
	var children:Array[Node]=tileset_preview.get_children()
	for child:Node in children:
		child.queue_free()
	var tmp:TileMap=input.preview.instantiate() as TileMap
	tileset_preview.add_child(tmp)
	#TODO might need to change selection based on different sizes 
	set_possible_spawn_grid(input.stage_pickup_map.map)
	set_spawn_percent(input.stage_pickup_map.pickup_chance)

