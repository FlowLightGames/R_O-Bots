extends Node2D
class_name SolidExplosionRaycast

@export var Top:RayCast2D
@export var Down:RayCast2D
@export var Left:RayCast2D
@export var Right:RayCast2D

func enable(what:bool)->void:
	Top.enabled=what
	Down.enabled=what
	Left.enabled=what
	Right.enabled=what

func resize_raycasts(to_power:int)->void:
	Top.target_position=Vector2i(0,to_power*16)
	Down.target_position=Vector2i(0,to_power*16)
	Left.target_position=Vector2i(0,to_power*16)
	Right.target_position=Vector2i(0,to_power*16)

func get_raycast_targets_and_extents()->Dictionary:
	var output:Dictionary={}
	var objects:Array[Node2D]=[]
	
	Top.force_raycast_update()
	Down.force_raycast_update()
	Left.force_raycast_update()
	Right.force_raycast_update()
	
	output["Objects"]=objects
	
	var Top_ext:int=0
	var Down_ext:int=0
	var Left_ext:int=0
	var Right_ext:int=0
	
	if Top.is_colliding():
		Top_ext=abs(roundi(to_local(Top.get_collision_point()).y)/16)
		objects.append(Top.get_collider())
	else:
		Top_ext=roundi(Top.target_position.y)/16
	
	if Down.is_colliding():
		Down_ext=abs(roundi(to_local(Down.get_collision_point()).y)/16)
		objects.append(Down.get_collider())
	else:
		Down_ext=roundi(Down.target_position.y)/16
	
	if Right.is_colliding():
		Right_ext=abs(roundi(to_local(Right.get_collision_point()).x)/16)
		objects.append(Right.get_collider())
		
	else:
		Right_ext=roundi(Right.target_position.y)/16
	
	if Left.is_colliding():
		Left_ext=abs(roundi(to_local(Left.get_collision_point()).x)/16)
		objects.append(Left.get_collider())
	else:
		Left_ext=roundi(Left.target_position.y)/16
	
	output["Extents"]=Vector4i(Top_ext,Down_ext,Left_ext,Right_ext)
	
	return output
