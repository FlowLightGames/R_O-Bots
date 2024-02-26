extends AnimatableBody2D
class_name BombBase

@export var kickable:bool=true
@export var throwable:bool=true
@export var bomb_sprite:Sprite2D
@export var affiliated_player:PlayerCharacter
@export var placed_with_color:int=0
@export var placed_with_power:int=1
@export var bomb_type:BombList.BOMBTYPE=BombList.BOMBTYPE.DEFAULT

var is_moving:bool=false
var motion_vec:Vector2i=Vector2i.ZERO
var disabled:bool=false

func _physics_process(delta:float)->void:
	if is_moving:
		var collision:KinematicCollision2D=move_and_collide(motion_vec*120*delta,false)
		if collision:
			#var collision_point:Vector2=collision.get_position()-Vector2(motion_vec)*8.0
			var collision_point:Vector2=position-Vector2(motion_vec)*7.5
			position=Vector2((roundi(collision_point.x)/16)*16+8,(roundi(collision_point.y)/16)*16+8)
			motion_vec=Vector2i.ZERO
			is_moving=false

func kick(direction:Vector2i)->void:
	if !is_moving:
		if !(move_and_collide(direction*8,true)):
			is_moving=true
			motion_vec=direction

func explode()->void:
	if !disabled:
		disabled=true
		placed_with_power=max(placed_with_power,1)


func _on_explosion_timer_timeout()->void:
	explode()
