extends TileMap
class_name DestroyablesRandomSpawner
@export
var possible_spawns:Array[PackedScene]
@export_range(0.0,1.0)
var fill_percent:float=0.5
@export 
var map:MapBase

func pick_random_from_array(rng:RandomNumberGenerator,arr:Array[Vector2i])->Vector2i:
	if !(arr.is_empty()):
		var random_idx:int=posmod(rng.randi(),arr.size())
		var item:Vector2i=arr[random_idx]
		arr.remove_at(random_idx)
		return item
	else:
		return Vector2i(-1,-1)

func spawn_block(pos:Vector2i)->void:
	var tmp_spawn:BrickBase=(possible_spawns.pick_random() as PackedScene).instantiate()
	tmp_spawn.tile_pos=pos
	add_child(tmp_spawn)
	tmp_spawn.position=pos*(tile_set.tile_size)+Vector2i(8,8)
	tmp_spawn.map=map
	map.destroyables_ref_dict[pos]=tmp_spawn

func spawn_with_seed(seed:int)->void:
	var rng:RandomNumberGenerator=RandomNumberGenerator.new()
	rng.seed=seed
	
	var marked_cells:Array[Vector2i]=get_used_cells(0)
	var number_of_marked_cells:int=marked_cells.size()
	
	for i:int in range(int(fill_percent*number_of_marked_cells)):
		#var tmp_spawn:BrickBase=(possible_spawns.pick_random() as PackedScene).instantiate()
		var tmp_pos:Vector2i= pick_random_from_array(rng,marked_cells)
		spawn_block(tmp_pos)
		#tmp_spawn.tile_pos=tmp_pos
		#add_child(tmp_spawn)
		#tmp_spawn.position=tmp_pos*(tile_set.tile_size)+Vector2i(8,8)
		#tmp_spawn.map=map
		#map.destroyables_ref_dict[tmp_pos]=tmp_spawn
	
	clear()

func _ready()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		spawn_with_seed(SteamLobby.random_seed)
	else:
		spawn_with_seed(randi())

