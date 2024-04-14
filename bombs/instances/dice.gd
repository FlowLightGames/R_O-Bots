extends BombBase
class_name DiceBomb

var explosion:PackedScene=load("res://bombs/explosion_instances/default_explosion.tscn")
@export var solid_explosion_raycast:SolidExplosionRaycast

func _ready()->void:
	(bomb_sprite.material as ShaderMaterial).set_shader_parameter("Type",placed_with_color)

func explode()->void:
	if !disabled:
		position=Vector2((roundi(position.x)/16)*16+(signi(position.x)*8),(roundi(position.y)/16)*16+(signi(position.y)*8))
		solid_explosion_raycast.enable(true)
		solid_explosion_raycast.resize_raycasts(placed_with_power)
		var result:Dictionary=solid_explosion_raycast.get_raycast_targets_and_extents()
		solid_explosion_raycast.enable(false)
		var objects:Array[Node2D]=[]
		if result.has("Objects"):
			objects=result["Objects"]
		for i:Node2D in objects:
			if i is BrickBase:
				(i as BrickBase).spawn_pickup_and_free()
		var extents:Vector4i=Vector4i(placed_with_power,placed_with_power,placed_with_power,placed_with_power)
		if result.has("Extents"):
			extents=result["Extents"]
		
		var explosion_spawn:DefaultExplosion=explosion.instantiate() as DefaultExplosion
		
		explosion_spawn.top_extent=extents.x
		explosion_spawn.down_extent=extents.y
		explosion_spawn.left_extent=extents.z
		explosion_spawn.right_extent=extents.w
		
		get_parent().call_deferred("add_child", explosion_spawn)
		explosion_spawn.set_deferred("position",self.position)
		explosion_spawn.set_deferred("color",self.placed_with_color)
		explosion_spawn.call_deferred("start_life_lifetime" )
		disabled=true
		if is_instance_valid(affiliated_player):
			affiliated_player.Bomb_Ref_List.erase(self)
		queue_free()


func _on_animation_player_animation_finished(_anim_name:String)->void:
	bomb_sprite.frame=posmod(placed_with_power-1,6)
