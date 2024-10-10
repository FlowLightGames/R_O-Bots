extends Node2D
class_name ZeusLightning

@export var dmg_raycast:RayCast2D
@export var lightning_sprite:Sprite2D

func set_color(color:int)->void:
	(lightning_sprite.material as ShaderMaterial).set_shader_parameter("Type",color)
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	dmg_raycast.force_raycast_update()
	var hit_target:Object=dmg_raycast.get_collider()
	if hit_target:
		if hit_target is BrickBase:
			(hit_target as BrickBase).spawn_pickup_and_free()
		elif hit_target is BombBase:
			(hit_target as BombBase).explode()
		elif hit_target is EnemyBase:
			(hit_target as EnemyBase).damage()
		elif hit_target is PlayerCharacter:
			(hit_target as PlayerCharacter).damage()
	
