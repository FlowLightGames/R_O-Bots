extends TileMap

var pickup_scene:PackedScene=load("res://pickup/pickup.tscn") as PackedScene

func spawn_pickups()->void:
	
	var marked_cells:Array[Vector2i]=get_used_cells(0)
	var number_of_marked_cells:int=marked_cells.size()
	
	for n:int in range(0,2):
		for i:PickUp.PICKUP in PickUp.PICKUP.values():
			#var tmp_spawn:BrickBase=(possible_spawns.pick_random() as PackedScene).instantiate()
			var tmp_pos:Vector2i= pick_random_from_array(marked_cells)
			spawn_pickup(tmp_pos,i)
	clear()

func spawn_pickup(pos:Vector2i,what:PickUp.PICKUP)->void:
	var tmp_spawn:PickUp=pickup_scene.instantiate()
	tmp_spawn.position=pos*(tile_set.tile_size)+Vector2i(8,8)
	tmp_spawn.type=what
	add_child(tmp_spawn)

func pick_random_from_array(arr:Array[Vector2i])->Vector2i:
	if !(arr.is_empty()):
		var random_idx:int=posmod(randi(),arr.size())
		var item:Vector2i=arr[random_idx]
		arr.remove_at(random_idx)
		return item
	else:
		return Vector2i(-1,-1)

func _ready()->void:
	spawn_pickups()
