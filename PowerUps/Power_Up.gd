extends Area2D

@export var type = Vector2(0,0)
@onready var destroyable=false

func _ready():
	set_type(type)

func set_type(idx: Vector2):
	type=idx
	$Sprite2D.region_rect.position=idx*16

func destroy():
	if(destroyable):
		queue_free()

func _on_Power_Up_body_entered(body):
	body.call_deferred("got_item", type)
	queue_free()


func _on_Timer_timeout():
	destroyable=true
