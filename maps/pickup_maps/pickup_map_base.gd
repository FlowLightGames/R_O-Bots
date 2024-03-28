extends Resource

class_name PickUpMap

@export var map:Array[PickUpOptionStruct]

@export_range(0.0,1.0) var pickup_chance:float

func sort_map()->void:
	map.sort_custom(compare_function)

func compare_function(a:PickUpOptionStruct,b:PickUpOptionStruct)->int:
	#-1 if a before b
	#1 if a  after b
	#0 if equal
	if int(a.what)>int(b.what):
		return 1
	elif int(a.what)<int(b.what):
		return -1
	else:
		return 0
