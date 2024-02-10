extends TileMap

@export
var possible_spawns:Array[PackedScene]
@export_range(0.0,1.0)
var fill_percent:float=0.5
@export 
var map:MapBase

func _ready()->void:
	var marked_cells:Array[Vector2i]=get_used_cells(0)
	var number_of_marked_cells:int=marked_cells.size()
	
	for i:int in range(int(fill_percent*number_of_marked_cells)):
		var tmp_spawn:BrickBase=(possible_spawns.pick_random() as PackedScene).instantiate()
		var tmp_pos:Vector2i=marked_cells.pick_random()
		add_child(tmp_spawn)
		tmp_spawn.position=tmp_pos*(tile_set.tile_size)+Vector2i(8,8)
		tmp_spawn.map=map
		marked_cells.erase(tmp_pos)
	
	clear()

