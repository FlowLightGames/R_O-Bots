extends StaticBody2D

var disabled:bool=false
var shot:PackedScene=load("res://maps/interactables/instances/turret_shot.tscn") as PackedScene

func shoot(to:Vector2i)->void:
	var tmp_shot:TurretShot=shot.instantiate() as TurretShot
	tmp_shot.direction=to
	tmp_shot.position=position+Vector2(to)*6
	tmp_shot.ignored_bodies.append(self)
	get_parent().add_child(tmp_shot)
