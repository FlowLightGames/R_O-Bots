extends StaticBody2D
class_name BrickBase

@export var visual_sprite:Sprite2D
@export var destruction_sprite:Sprite2D
@export var destruction_animationplayer:AnimationPlayer

var map:MapBase

func spawn_pickup_and_free()->void:
	visual_sprite.visible=false
	destruction_sprite.visible=true
	destruction_animationplayer.play("Destroy")


func _on_animation_player_animation_finished(_anim_name:String)->void:
	var spawn:bool=false
	var random_f:float=randf()
	if map.possible_pickups.pickup_chance==0.0:
		pass
	else:
		spawn=(random_f<=map.possible_pickups.pickup_chance)
	if(spawn):
		var picked_struct:PickUpOptionStruct=map.pick_up_with_weights()
		if picked_struct:
			var tmp_pickup:PickUp=map.pickup_scene.instantiate() as PickUp
			tmp_pickup.type=picked_struct.what
			get_parent().add_child(tmp_pickup)
			tmp_pickup.position=position
	queue_free()
