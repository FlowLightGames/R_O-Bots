extends ExplosionBase
class_name BananaExplosion



@export var time_to_live:float=1.0
@export var collision_shape_h:CollisionShape2D
@export var collision_shape_v:CollisionShape2D
@export var animation_player:AnimationPlayer

func start_life_lifetime()->void:
	
	animation_player.play("Default")
	timer.wait_time=time_to_live
	timer.start()
	
	collision_shape_h.set_deferred("disabled",false)
	collision_shape_v.set_deferred("disabled",false)
	
