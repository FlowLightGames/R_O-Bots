extends StaticBody2D
class_name BrickBase

@export var visual_sprite:Sprite2D
@export var destruction_sprite:Sprite2D
@export var destruction_animationplayer:AnimationPlayer

var map:MapBase
var tile_pos:Vector2i=Vector2i.ZERO
var currently_being_destroyed:bool=false

func spawn_pickup_and_free()->void:
	visual_sprite.visible=false
	destruction_sprite.visible=true
	currently_being_destroyed=true
	destruction_animationplayer.play("Destroy")


func _on_animation_player_animation_finished(_anim_name:String)->void:
	var rng:RandomNumberGenerator=RandomNumberGenerator.new()
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		rng.seed=SteamLobby.random_seed*int(global_position.x)+int(global_position.y)
	else:
		rng.randomize()
	var spawn:bool=false
	var random_f:float=rng.randf()
	if map.possible_pickups.pickup_chance==0.0:
		pass
	else:
		spawn=(random_f<=map.possible_pickups.pickup_chance)
	if(spawn):
		var picked_struct:PickUpOptionStruct=map.pick_up_with_weights(rng)
		if picked_struct:
			var tmp_pickup:PickUp=map.pickup_scene.instantiate() as PickUp
			tmp_pickup.type=picked_struct.what
			get_parent().add_child(tmp_pickup)
			tmp_pickup.position=position
	map.destroyables_ref_dict.erase(tile_pos)
	queue_free()
