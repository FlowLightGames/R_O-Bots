extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_exited(body):
#	get_parent().set_collision_layer_bit(4,true)
	var bodies = get_overlapping_bodies()
	if(bodies.is_empty()):
		get_parent().set_collision_layer_value(4,true)
		get_parent().pickable=false
#		get_parent().set_collision_mask_bit(4,true)
		queue_free()
