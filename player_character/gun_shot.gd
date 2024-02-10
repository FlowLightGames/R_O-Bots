extends Line2D
class_name GunShot

@export var end_sprite:Sprite2D
@export var start_sprite:Sprite2D

func set_length_and_rotation(length:float,rotation_deg:float)->void:
	points[1].x=length
	rotation_degrees=rotation_deg
	end_sprite.position.x=length

func set_color(color:int)->void:
	(end_sprite.material as ShaderMaterial).set_shader_parameter("Type",color)
	(start_sprite.material as ShaderMaterial).set_shader_parameter("Type",color)
	(self.material as ShaderMaterial).set_shader_parameter("Type",color)

func _on_timer_timeout()->void:
	queue_free()


