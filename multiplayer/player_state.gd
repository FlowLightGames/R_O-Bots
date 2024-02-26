extends RefCounted
class_name PlayerState

enum Actions{SHOT_FIRED}

var player_number:int=0
var position:Vector2=Vector2.ZERO
var velocity:Vector2=Vector2.ZERO
var pickup_stats:PickUpStats=PickUpStats.new()
var taken_aktions:Array[Actions]
