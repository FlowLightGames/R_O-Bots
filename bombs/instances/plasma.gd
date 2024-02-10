extends BombBase
class_name PlasmaBomb

var explosion:PackedScene=load("res://bombs/explosion_instances/piercing_explosion.tscn")

@export var piercing_explosion_raycast:SolidExplosionRaycast

func _ready()->void:
	(bomb_sprite.material as ShaderMaterial).set_shader_parameter("Type",placed_with_color)

func explode()->void:
	if !disabled:
		position=Vector2((roundi(position.x)/16)*16+8,(roundi(position.y)/16)*16+8)
		piercing_explosion_raycast.enable(true)
		piercing_explosion_raycast.resize_raycasts(placed_with_power)
		var result:Dictionary=piercing_explosion_raycast.get_raycast_targets_and_extents()
		piercing_explosion_raycast.enable(false)
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

