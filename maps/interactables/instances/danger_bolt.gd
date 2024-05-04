extends Area2D

var explosion_scene:PackedScene=load("res://bombs/explosion_instances/piercing_explosion.tscn") as PackedScene
var on_cd:bool=false
@export
var cd_timer:Timer

func _on_cd_timer_timeout()->void:
	on_cd=false


func _on_area_entered(area:Node2D)->void:
	if !on_cd:
		on_cd=true
		var explosion_spawn:DefaultExplosion=explosion_scene.instantiate() as DefaultExplosion
		explosion_spawn.top_extent=6
		explosion_spawn.down_extent=6
		explosion_spawn.left_extent=6
		explosion_spawn.right_extent=6
		
		cd_timer.start(1.0)
		self.call_deferred("add_child", explosion_spawn)
		explosion_spawn.set_deferred("position",Vector2.ZERO)
		explosion_spawn.set_deferred("color",1)
		explosion_spawn.call_deferred("start_life_lifetime" )
		


func _on_body_entered(body:Node2D)->void:
	if !on_cd:
		on_cd=true
		var explosion_spawn:DefaultExplosion=explosion_scene.instantiate() as DefaultExplosion
		explosion_spawn.top_extent=6
		explosion_spawn.down_extent=6
		explosion_spawn.left_extent=6
		explosion_spawn.right_extent=6
		
		cd_timer.start(1.0)
		self.call_deferred("add_child", explosion_spawn)
		explosion_spawn.set_deferred("position",Vector2.ZERO)
		explosion_spawn.set_deferred("color",1)
		explosion_spawn.call_deferred("start_life_lifetime" )
