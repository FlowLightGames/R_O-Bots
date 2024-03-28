extends ExplosionBase
class_name HydrogenExplosion

@export var collision_shape:CollisionShape2D
@export var animation_player:AnimationPlayer

func start_life_lifetime()->void:
	
	animation_player.play("Default")
	timer.wait_time=time_to_life
	timer.start()
	
	collision_shape.set_deferred("disabled",false)
