extends RigidBody2D

#var EXP_PRIME=preload("res://Bombs/Normal/EXP_AREA_PRIME.tscn")

@onready var Board=get_parent()

@onready var coll=$CollisionShape2D
@onready var ani=$AnimatedSprite2D
@onready var exp_tile=$EXPLOSION
@onready var exp_box=$Hurt_Box

@onready var r_top=$r_Top
@onready var r_bottom=$r_Bottom
@onready var r_left=$r_Left
@onready var r_right=$r_Right


@onready var hit_time=$hitbox_timer
@onready var timer=$Timer

var color=0
var b_owner
var power=1
var pickable=true
var exploded=false

func set_power(p: int):
	power=posmod(randi(),7)+1
	r_top.target_position=Vector2(0,(8+(power-1)*16)-1)
	r_bottom.target_position=Vector2(0,(8+(power-1)*16)-1)
	r_left.target_position=Vector2(0,(8+(power-1)*16)-1)
	r_right.target_position=Vector2(0,(8+(power-1)*16)-1)

func explode():
	if(!exploded):
		#set Position at Explodepoint
		exploded=true
		mode=FREEZE_MODE_STATIC
		var boardpos=Board.get_board_pos(global_position+Vector2(8,8))
		global_position=boardpos*16
		
		#disable collider
		coll.disabled=true
		$Area2D/CollisionShape2D.disabled=true
		
		var wr = weakref(b_owner)
		if (wr.get_ref()):
			b_owner.update_bomb_number()
		
		var tmp_t=power
		var tmp_b=power
		var tmp_l=power
		var tmp_r=power
		var other=null
		
		ani.visible=false

		coll.disabled=true
		
		timer.stop()
		
		r_top.force_raycast_update()
		r_bottom.force_raycast_update()
		r_left.force_raycast_update()
		r_right.force_raycast_update()
		
		if r_top.is_colliding():
			var col_point=Board.get_board_pos(r_top.get_collision_point()+Vector2(0,-1))
			tmp_t=abs(col_point.y-boardpos.y)
			other=r_top.get_collider()
			if(other.is_in_group("Brick")):
				other.destroy()
			
		if r_bottom.is_colliding():
			var col_point=Board.get_board_pos(r_bottom.get_collision_point()+Vector2(0,1))
			tmp_b=abs(col_point.y-boardpos.y)
			other=r_bottom.get_collider()
			if(other.is_in_group("Brick")):
				other.destroy()
			
		if r_left.is_colliding():
			var col_point=Board.get_board_pos(r_left.get_collision_point()+Vector2(-1,0))
			tmp_l=abs(col_point.x-boardpos.x)
			other=r_left.get_collider()
			if(other.is_in_group("Brick")):
				other.destroy()
			
		if r_right.is_colliding():
			var col_point=Board.get_board_pos(r_right.get_collision_point()+Vector2(1,0))
			tmp_r=abs(col_point.x-boardpos.x)
			other=r_right.get_collider()
			if(other.is_in_group("Brick")):
				other.destroy()
			
		for n in tmp_t:
			exp_tile.set_cellv(Vector2(0,-n),0)
		for n in tmp_b:
			exp_tile.set_cellv(Vector2(0,n),0)
		for n in tmp_l:
			exp_tile.set_cellv(Vector2(-n,0),0)
		for n in tmp_r:
			exp_tile.set_cellv(Vector2(n,0),0)

		var used_rect=exp_tile.get_used_rect()
		
		var vert=$Hurt_Box/vert
		vert.disabled=false
		vert.shape.size.x=(used_rect.size.x/2)*16-1
		vert.position.x=used_rect.position.x*16+used_rect.size.x*8-8
	#	print ("vert"+str(vert.position))
	#	print ("vert"+str(vert.shape.extents))
		
		var hori=$Hurt_Box/hori
		hori.disabled=false
		hori.shape.size.y=(used_rect.size.y/2)*16-1
		hori.position.y=used_rect.position.y*16+used_rect.size.y*8-8
	#	print ("hori"+str(hori.position))
	#	print ("hori"+str(hori.shape.extents))
		
		exp_box.monitoring=true
		
		exp_tile.update_bitmask_region(used_rect.position,used_rect.end)
		var tex=exp_tile.tile_set.tile_get_texture(0)
		tex.one_shot=true
		tex.current_frame=0
		hit_time.start()

func _ready():
	ani.playing=true
#	ani.material.set_shader_param("Type",color)
	exp_tile.material.set_shader_parameter("Type",color)

func _on_Timer_timeout():
	explode()

func _on_hitbox_timer_timeout():
#	b_owner.call_deferred("update_bomb_number")
	queue_free()

func _on_Hurt_Box_body_entered(body):
	if(body.is_in_group("Brick")):
		body.destroy()
	if(body.is_in_group("Bomb")):
		body.call_deferred("explode")


func _on_Hurt_Box_area_entered(area):
	if(area.is_in_group("Power_up")):
		area.call_deferred("destroy")
