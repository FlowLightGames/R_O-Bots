extends AnimatableBody2D
class_name BombBase

@export var kickable:bool=true
@export var throwable:bool=true
@export var bomb_sprite:Sprite2D
@export var affiliated_player:PlayerCharacter
@export var affiliated_map:MapBase
@export var occupancy_area:Area2D
@export var placed_with_color:int=0
@export var placed_with_power:int=1
@export var placed_with_direction:Vector2i=Vector2i(0,0)
@export var bomb_type:BombList.BOMBTYPE=BombList.BOMBTYPE.DEFAULT
@export var explosion_timer:Timer
@export var one_way_bomb_collision:OneWayCollision
@export var bounce_check:Area2D

var is_moving:bool=false
var is_flying:bool=false
var motion_vec:Vector2i=Vector2i.ZERO
var disabled:bool=false

var toggled_on:bool=true
var col_layer_toggle_buffer:int=0
var col_mask_toggle_buffer:int=0

func _physics_process(delta:float)->void:
	if is_moving:
		var collision:KinematicCollision2D=move_and_collide(motion_vec*120*delta,false)
		if collision:
			#var collision_point:Vector2=collision.get_position()-Vector2(motion_vec)*8.0
			var collision_point:Vector2=position-Vector2(motion_vec)*7.5
			position=Vector2((roundi(collision_point.x)/16)*16+8,(roundi(collision_point.y)/16)*16+8)
			motion_vec=Vector2i.ZERO
			is_moving=false

func toggle_collisions()->void:
	one_way_bomb_collision.toggle_collision()
	if toggled_on:
		col_mask_toggle_buffer=collision_mask
		col_layer_toggle_buffer=collision_layer
		collision_layer=0
		collision_mask=0
		toggled_on=false
	else:
		collision_layer=col_layer_toggle_buffer
		collision_mask=col_mask_toggle_buffer
		toggled_on=true

func bounce(direction:Vector2i,length:int,amplitude:int,duration:float)->void:
	var offset:Vector2=Vector2(0.0,-10.0) 
	bomb_sprite.offset=offset
	position=Vector2((roundi(position.x)/16)*16+(signi(position.x)*8),(roundi(position.y)/16)*16+(signi(position.y)*8))
	var tween:Tween=create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self,"position",position+Vector2(0.5*length*direction),duration*0.5)
	tween.tween_property(bomb_sprite,"offset",Vector2(0,-amplitude)+offset,duration*0.5)
	tween.chain().set_ease(Tween.EASE_IN)
	tween.tween_property(self,"position",position+Vector2(length*direction),duration*0.5)
	tween.tween_property(bomb_sprite,"offset",Vector2(0,0)+offset,duration*0.5)
	tween.chain().tween_callback(on_bounce_finished)

func on_bounce_finished()->void:
	#TODO REDO THIS WITHOUT USING PHYSICS ENGINE
	#CHECK MAP PLAYER,BRICKS,STATICS, POSITION IN LOCAL MAP SPACE AND GO OFF OF THAT
	var bodies:Array[Node2D]=bounce_check.get_overlapping_bodies()
	var hit:bool=false
	for n:Node2D in bodies:
			if n is PlayerCharacter:
				#TODO DAMAGE? logic
				pass
			elif n is EnemyBase:
				#TODO DAMAGE? logic
				pass
			hit=true
	if hit:
		bounce(motion_vec,16,16,0.4)
	else:
		#make bomb normal height again
		z_index=2
		var tween:Tween=create_tween()
		tween.tween_property(bomb_sprite,"offset",Vector2(0.0,0.0),0.05)
		explosion_timer.start()
		toggle_collisions()
		motion_vec=Vector2i.ZERO
		is_flying=false
		disabled=false

func kick(direction:Vector2i)->void:
	if !is_moving:
		if !(move_and_collide(direction*8,true)):
			is_moving=true
			motion_vec=direction

func throw(direction:Vector2i)->void:
	if !is_flying:
		#make bomb over head of stuff
		z_index=4
		motion_vec=direction
		explosion_timer.stop()
		toggle_collisions()
		is_flying=true
		disabled=true
		bounce(direction,32,16,0.6)

func explode()->void:
	if !disabled:
		disabled=true
		placed_with_power=max(placed_with_power,1)

func _on_explosion_timer_timeout()->void:
	explode()

