extends GPUParticles2D

@export var audio:AudioStreamPlayer
var ignored_bodies:Array[Node2D]=[]
var hurtbox:Area2D

func _on_ttl_timeout()->void:
	queue_free()

func _on_hurtbox_timeout()->void:
	hurtbox.monitorable=false
	hurtbox.monitoring=false

func _on_area_2d_body_entered(body:Node2D)->void:
	if !(body in ignored_bodies):
		if body is PlayerCharacter:
			(body as PlayerCharacter).damage()
		elif body is EnemyBase:
			(body as EnemyBase).damage()

func _ready()->void:
	emitting=true
