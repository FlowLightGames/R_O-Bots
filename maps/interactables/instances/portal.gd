extends Node2D
class_name Portal

@export var type:int=0
var other_portal:Portal=null
var ignored_bodies:Array[Node2D]

func _ready()->void:
	if !other_portal:
		var other_portals:Array[Node]=get_tree().get_nodes_in_group("Portal")
		for n:Node in other_portals:
			#print("found other portal")
			if n is Portal:
				#print("is class portal")
				if (n as Portal).type==type:
					#print("is type portal")
					(n as Portal).other_portal=self
					other_portal=(n as Portal)
					#print("found matched portals")
					break
	
func _on_area_2d_body_entered(body:Node2D)->void:
	print("entered portal")
	if !(body in ignored_bodies):
		ignored_bodies.append(body)
		if other_portal:
			other_portal.ignored_bodies.append(body)
			body.global_position=other_portal.global_position

func _on_area_2d_body_exited(body:Node2D)->void:
	ignored_bodies.erase(body)
	if other_portal:
		other_portal.ignored_bodies.erase(body)
