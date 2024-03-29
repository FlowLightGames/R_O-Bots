extends ExplosionBase
class_name EExplosion

@export var collision_shape_a:CollisionShape2D
@export var collision_shape_b:CollisionShape2D
@export var collision_shape_c:CollisionShape2D
@export var collision_shape_d:CollisionShape2D
@export var animation_player:AnimationPlayer
@export var explosion_sprite:Sprite2D
var color:int

func start_life_lifetime()->void:
	(explosion_sprite.material as ShaderMaterial).set_shader_parameter("Type",color)
	
	animation_player.play("Default")
	timer.wait_time=time_to_life
	timer.start()
	
	collision_shape_a.set_deferred("disabled",false)
	collision_shape_b.set_deferred("disabled",false)
	collision_shape_c.set_deferred("disabled",false)
	collision_shape_d.set_deferred("disabled",false)
	
