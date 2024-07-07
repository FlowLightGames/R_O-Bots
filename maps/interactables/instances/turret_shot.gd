extends Area2D

class_name TurretShot

var direction:Vector2=Vector2.ZERO
var ignored_bodies:Array[Node2D]=[]
var speed:int=120
var disabled:bool=false
#@export var sprite:Sprite2D

func _physics_process(delta:float)->void:
	if !disabled:
		position+=(direction*speed*delta)

func _on_body_entered(body:Node2D)->void:
	if !(body in ignored_bodies):
		disabled=true
		if body is PlayerCharacter:
			(body as PlayerCharacter).damage()
		queue_free()
