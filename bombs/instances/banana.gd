extends BombBase
class_name BananaBomb

var explosion:PackedScene=load("res://bombs/explosion_instances/banana_explosion.tscn")
var placed_with_direction:Vector2i

func explode()->void:
	if !disabled:
		position=Vector2((roundi(position.x)/16)*16+8,(roundi(position.y)/16)*16+8)
		var explosion_spawn:BananaExplosion=explosion.instantiate() as BananaExplosion
		get_parent().call_deferred("add_child", explosion_spawn)
		explosion_spawn.set_deferred("position",self.position)
		explosion_spawn.set_deferred("color",self.placed_with_color)
		explosion_spawn.call_deferred("start_life_lifetime" )
		explosion_spawn.set_deferred("rotation",Vector2(placed_with_direction).angle())
		disabled=true
		if is_instance_valid(affiliated_player):
			affiliated_player.Bomb_Ref_List.erase(self)
		queue_free()
