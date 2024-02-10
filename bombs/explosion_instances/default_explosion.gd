extends ExplosionBase
class_name DefaultExplosion
@export var animated_texture:AnimatedTexture
@export var tilemap:TileMap

@export var collision_shape_h:CollisionShape2D
@export var collision_shape_v:CollisionShape2D

var color:int

var top_extent:int=0
var down_extent:int=0
var right_extent:int=0
var left_extent:int=0

func start_life_lifetime()->void:
	(tilemap.material as ShaderMaterial).set_shader_parameter("Type",color)
	
	var ttl:float=0.0
	for n:int in range(0,animated_texture.frames):
		ttl+=animated_texture.get_frame_duration(n)
		timer.wait_time=ttl
		timer.start()
	collision_shape_h.set_deferred("disabled",false)
	collision_shape_v.set_deferred("disabled",false)
	(collision_shape_h.shape as RectangleShape2D).size.x=(left_extent+right_extent+1)*16-2
	(collision_shape_v.shape as RectangleShape2D).size.y=(top_extent+down_extent+1)*16-2
	
	collision_shape_h.position.x=(right_extent*16-left_extent*16)/2
	collision_shape_v.position.y=(down_extent*16-top_extent*16)/2
	
	tilemap.set_cell(0,Vector2i(0,0),0,Vector2i(0,0),0)
	
	for n:int in range(0,top_extent):
		tilemap.set_cell(0,Vector2i(0,-1)*(n+1),0,Vector2i(0,0),0)
	
	for n:int in range(0,down_extent):
		tilemap.set_cell(0,Vector2i(0,1)*(n+1),0,Vector2i(0,0),0)
	
	for n:int in range(0,left_extent):
		tilemap.set_cell(0,Vector2i(-1,0)*(n+1),0,Vector2i(0,0),0)
	
	for n:int in range(0,right_extent):
		tilemap.set_cell(0,Vector2i(1,0)*(n+1),0,Vector2i(0,0))
	
	tilemap.set_cells_terrain_connect(0,tilemap.get_used_cells(0),0,0)
