extends Area2D
class_name FireBall

var direction:Vector2=Vector2.ZERO
var ignored_bodies:Array[Node2D]=[]
var speed:int=60
@export var sprite:Sprite2D

func _ready()->void:
	sprite.rotation=direction.angle()

func _physics_process(delta:float)->void:
	position+=(direction*speed*delta)


func _on_body_entered(body:Node2D)->void:
	if !(body in ignored_bodies):
		if body is PlayerCharacter:
			body.damage()
			queue_free()
		elif body is EnemyBase:
			body.damage()
			queue_free()
		elif body is BombBase:
			(body as BombBase).explode()
		else:
			queue_free()
