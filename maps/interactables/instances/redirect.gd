extends Area2D
class_name ReDirect

@export var direction:Vector2i=Vector2i.ZERO


func _on_body_entered(body:Node2D)->void:
	if body is BombBase:
		if (body as BombBase).is_moving&&(body as BombBase).motion_vec!=direction:
			body.global_position=global_position
			(body as BombBase).motion_vec=direction
