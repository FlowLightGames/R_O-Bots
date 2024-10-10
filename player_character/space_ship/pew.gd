extends Area2D
class_name Pew

var direction:Vector2=Vector2.ZERO
var ignored_bodies:Array[Node2D]=[]
var speed:int=120
var disabled:bool=false
@export var sprite:Sprite2D

func _ready()->void:
	sprite.rotation=direction.angle()

func _physics_process(delta:float)->void:
	if !disabled:
		position+=(direction*speed*delta)

func init_free()->void:
	disabled=true
	queue_free()

func _on_body_entered(body:Node2D)->void:
	if !disabled:
		if !(body in ignored_bodies):
			if body is PlayerCharacter:
				body.damage()
			elif body is EnemyBase:
				body.damage()
			elif body is BombBase:
				(body as BombBase).explode()
			else:
				pass
			init_free()
