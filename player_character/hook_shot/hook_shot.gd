extends Node2D
class_name HookShot

const SPEED:float=180.0
const MAX_RANGE:int=640

enum {
	EXTENDING,CONTRACTING,NEUTRAL
}
@export var head:Area2D
@export var line:Line2D
@export var current_map:MapBase

var direction:Vector2i=Vector2i.RIGHT
var current_hold:Node2D=null
var state:int=EXTENDING
var ignored_bodies:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	self.rotation=Vector2(direction).angle()
	head.monitorable=true
	head.monitoring=true

func _physics_process(delta:float)->void:
	match state:
		EXTENDING:
			head.position.x+=SPEED*delta
			line.set_point_position(1,Vector2(head.position.x,0.0))
			if head.position.x>=640.0:
				state=CONTRACTING
		CONTRACTING:
			head.position.x-=SPEED*delta
			line.set_point_position(1,Vector2(head.position.x,0.0))
			if head.position.x<=0.0:
				head.position.x=0.0
				line.set_point_position(1,Vector2(0.0,0.0))
				
				if current_hold:
					current_hold.reparent(current_map.player_nodes)
					current_hold.movement_blocked=false
					current_hold=null
				queue_free()
				state=NEUTRAL
		NEUTRAL:
			pass
		_:
			pass


func _on_area_2d_body_entered(body:Node2D)->void:
	if !(body in ignored_bodies):
		if state!=NEUTRAL:
			if (body is PlayerCharacter||body is EnemyBase)&&!current_hold:
				body.movement_blocked=true
				
				body.call_deferred("reparent",head)
				current_hold=body
				
			state=CONTRACTING
