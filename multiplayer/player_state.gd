extends RefCounted
class_name PlayerState

enum Actions{SHOT_FIRED}

var player_number:int=0
var position:Vector2=Vector2.ZERO
var reticle_position:Vector2=Vector2.ZERO
var direction:Vector2i=Vector2i.ZERO
var pickup_stats:PickUpStats=PickUpStats.new()
var taken_aktions:Array[Actions]
