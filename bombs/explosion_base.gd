extends Node2D
class_name ExplosionBase
@export var time_to_life:float
@export var timer:Timer

func start_life_lifetime()->void:
	timer.wait_time=time_to_life
	timer.start()


func _on_timer_timeout()->void:
	queue_free()

func handle_damage_body(input:Node2D)->void:
	if input is BombBase:
		(input as BombBase).explode()
	elif input is PlayerCharacter:
		(input as PlayerCharacter).damage()
	elif input is BrickBase:
		(input as BrickBase).spawn_pickup_and_free()
	elif input is PickUp:
		(input as PickUp).destroy()
	elif input is EnemyBase:
		(input as EnemyBase).damage()

func _on_hurtbox_body_entered(body:Node2D)->void:
	handle_damage_body(body)


func _on_hurtbox_area_entered(area:Node2D)->void:
	handle_damage_body(area)
