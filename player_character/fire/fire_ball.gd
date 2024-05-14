extends Area2D
class_name FireBall

var direction:Vector2=Vector2.ZERO
var ignored_bodies:Array[Node2D]=[]
var speed:int=60
var disabled:bool=false
@export var sprite:Sprite2D
@export var death_poof:GPUParticles2D
@export var trail:GPUParticles2D

func _ready()->void:
	sprite.rotation=direction.angle()

func _physics_process(delta:float)->void:
	if !disabled:
		position+=(direction*speed*delta)

func init_free()->void:
	disabled=true
	trail.emitting=false
	death_poof.emitting=true
	sprite.self_modulate=Color(0.0,0.0,0.0,0.0)


func _on_body_entered(body:Node2D)->void:
	if !disabled:
		if !(body in ignored_bodies):
			if body is PlayerCharacter:
				body.damage()
				init_free()
			elif body is EnemyBase:
				body.damage()
				init_free()
			elif body is BombBase:
				(body as BombBase).explode()
			else:
				init_free()


func _on_die_poof_finished()->void:
	queue_free()
