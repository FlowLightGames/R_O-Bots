extends BombBase
class_name HydrogenBomb

var explosion:PackedScene=load("res://bombs/explosion_instances/hydrogen_explosion.tscn")

@export var bomb_body:Sprite2D
@export var visual_animator:AnimationPlayer

func _ready()->void:
	(bomb_sprite.material as ShaderMaterial).set_shader_parameter("Type",placed_with_color)
	(bomb_body.material as ShaderMaterial).set_shader_parameter("Type",placed_with_color)
	disabled=true

func explode()->void:
	pass
	#if !disabled:
		#position=Vector2((roundi(position.x)/16)*16+8,(roundi(position.y)/16)*16+8)
		##solid_explosion_raycast.enable(true)
		##solid_explosion_raycast.resize_raycasts(placed_with_power)
		##var result:Dictionary=solid_explosion_raycast.get_raycast_targets_and_extents()
		##solid_explosion_raycast.enable(false)
		##var objects:Array[Node2D]=[]
		##if result.has("Objects"):
			##objects=result["Objects"]
		##for i:Node2D in objects:
			##if i is BrickBase:
				##(i as BrickBase).spawn_pickup_and_free()
		##var extents:Vector4i=Vector4i(placed_with_power,placed_with_power,placed_with_power,placed_with_power)
		##if result.has("Extents"):
			##extents=result["Extents"]
		##
		##var explosion_spawn:DefaultExplosion=explosion.instantiate() as DefaultExplosion
		##
		##explosion_spawn.top_extent=extents.x
		##explosion_spawn.down_extent=extents.y
		##explosion_spawn.left_extent=extents.z
		##explosion_spawn.right_extent=extents.w
		##
		##get_parent().call_deferred("add_child", explosion_spawn)
		##explosion_spawn.set_deferred("position",self.position)
		##explosion_spawn.set_deferred("color",self.placed_with_color)
		##explosion_spawn.call_deferred("start_life_lifetime" )
		#disabled=true
		#if is_instance_valid(affiliated_player):
			#affiliated_player.Bomb_Ref_List.erase(self)
		#queue_free()

#explode blocked so other bombs cant trigger it
#hence alternate function to destroy stuff after set animation
func launch()->void:
	position=Vector2((roundi(position.x)/16)*16+8,(roundi(position.y)/16)*16+8)
	visual_animator.play("Default")
	

func detonate()->void:
	var explosion_spawn:HydrogenExplosion=explosion.instantiate() as HydrogenExplosion
	get_parent().call_deferred("add_child", explosion_spawn)
	explosion_spawn.set_deferred("position",self.position)
	explosion_spawn.set_deferred("color",self.placed_with_color)
	explosion_spawn.call_deferred("start_life_lifetime")
	
	if is_instance_valid(affiliated_player):
		affiliated_player.Bomb_Ref_List.erase(self)
	queue_free()
