extends RigidBody2D

@onready var Board=get_parent()

@onready var coll=$CollisionShape2D
@onready var ani=$AnimatedSprite2D
@onready var exp_ani=$EXPLOSION
@onready var exp_box=$Hurt_Box


@onready var timer=$Timer

var color=0
var b_owner
var power=1
var pickable=true
var exploded=false

func set_power(p: int):
	pass

func explode():
	if(!exploded):
		exploded=true
		#set Position at Explodepoint
		mode=FREEZE_MODE_STATIC
		var boardpos=Board.get_board_pos(global_position+Vector2(8,8))
		global_position=boardpos*16
		
		#disable collider
		coll.disabled=true
		$Area2D/CollisionShape2D.disabled=true
		
		var wr = weakref(b_owner)
		if (wr.get_ref()):
			b_owner.update_bomb_number()
		
		$Hurt_Box/CollisionShape2D.disabled=false
		$Hurt_Box/CollisionShape2D2.disabled=false
		
		exp_box.monitoring=true
		
		ani.visible=false
		exp_ani.visible=true
		exp_ani.playing=true

func _ready():
	ani.playing=true

func _on_Timer_timeout():
	explode()

func _on_EXPLOSION_animation_finished():
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
