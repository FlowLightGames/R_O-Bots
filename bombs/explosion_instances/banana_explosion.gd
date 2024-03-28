extends ExplosionBase
class_name BananaExplosion



@export var collision_shape_h:CollisionShape2D
@export var collision_shape_v:CollisionShape2D
@export var animation_player:AnimationPlayer

func start_life_lifetime()->void:
	
	animation_player.play("Default")
	timer.wait_time=time_to_life
	timer.start()
	
	collision_shape_h.set_deferred("disabled",false)
	collision_shape_v.set_deferred("disabled",false)
	
