extends CharacterBody2D

class_name PlayerCharacter

var gunshot:PackedScene=load("res://player_character/gun_shot.tscn")

@export var BodyAnimation:AnimationPlayer
@export var FaceAnimation:AnimationPlayer
@export var IFramesAnimation:AnimationPlayer
@export var Face:Sprite2D
@export var Body:Sprite2D
@export var bomb_place_check:RayCast2D
@export var KnifeGunSprite:Sprite2D
@export var KnifeHurtBox:CollisionShape2D
@export var GunRayCast:RayCast2D
@export var KickerRayCast:RayCast2D
@export var death_timer:Timer

var i_frames:bool=false
@export var disabled:bool=false

var Action_UP:String ="0_Up"
var Action_DOWN:String ="0_Down"
var Action_LEFT:String ="0_Left"
var Action_RIGHT:String ="0_Right"
var Action_0:String ="0_Action_0"
var Action_1:String ="0_Action_1"

var Player_Number:int=0
var Player_Name:String

const BASE_MOVEMENT_SPEED:int=60

@export var map:MapBase

var Pickup_Stats:PickUpStats=PickUpStats.new()
var Body_Color:int=0
var Bomb_Ref_List:Array[BombBase]=[]

var current_view_direction:Vector2i=Vector2i(-1,1)
#special stuff for visual behavior
var front_back:String="front_"
var left_right:String="left"

func set_new_face(to:Texture2D)->void:
	Face.texture=to
func set_new_face_color(to:int)->void:
	(Face.material as ShaderMaterial).set_shader_parameter("Type",to)
func set_new_body(to:int)->void:
	var tmp_rect:Rect2=Body.region_rect
	tmp_rect.position=Vector2((tmp_rect.size.x)*to,0)
	Body.region_rect=tmp_rect
func set_new_body_color(to:int)->void:
	(Body.material as ShaderMaterial).set_shader_parameter("Type",to)
	Body_Color=to

func config_init(config:PlayerConfigMetaData)->void:
	set_new_body(config.Body_Base)
	set_new_body_color(config.Body_Color)
	set_new_face(config.Face_Texture)
	set_new_face_color(config.Face_Color)

func picked_up(what:PickUp.PICKUP)->void:
	match what:
		#BOMBTYPE
		PickUp.PICKUP.BANANA:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.BANANA
		PickUp.PICKUP.E:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.E
		PickUp.PICKUP.REMOTE:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.REMOTE
		PickUp.PICKUP.MINE:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.MINE
		PickUp.PICKUP.DICE:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.DICE
		PickUp.PICKUP.PLASMA:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.PLASMA
		PickUp.PICKUP.HYDROGEN:
			Pickup_Stats.BOMB_TYPE=BombList.BOMBTYPE.HYDROGEN
		#STAT_UP
		PickUp.PICKUP.LIFE_UP:
			Pickup_Stats.LIFE_UP+=1
		PickUp.PICKUP.FIRE_UP:
			Pickup_Stats.FIRE_UP+=1
		PickUp.PICKUP.BOMB_UP:
			Pickup_Stats.BOMB_UP+=1
		PickUp.PICKUP.SPEED_UP:
			Pickup_Stats.SPEED_UP+=1
		#STAT_DOWN
		PickUp.PICKUP.LIFE_DOWN:
			Pickup_Stats.LIFE_UP+=-1
		PickUp.PICKUP.FIRE_DOWN:
			Pickup_Stats.FIRE_UP+=-1
		PickUp.PICKUP.BOMB_DOWN:
			Pickup_Stats.BOMB_UP+=-1
		PickUp.PICKUP.SPEED_DOWN:
			Pickup_Stats.SPEED_UP+=-1
		#STAT_UP_MAX
		PickUp.PICKUP.LIFE_MAX:
			Pickup_Stats.LIFE_UP+=10
		PickUp.PICKUP.FIRE_MAX:
			Pickup_Stats.FIRE_UP+=10
		PickUp.PICKUP.BOMB_MAX:
			Pickup_Stats.BOMB_UP+=10
		PickUp.PICKUP.SPEED_MAX:
			Pickup_Stats.SPEED_UP+=10
		#BALLS
		PickUp.PICKUP.KICKER:
			Pickup_Stats.KICKER=true
		PickUp.PICKUP.DUNKER:
			Pickup_Stats.DUNKER=true
		#UNDECIDED YET
		PickUp.PICKUP.BRICK_WALKER:
			Pickup_Stats.BRICK_WALKER=true
		PickUp.PICKUP.UNDECIDED_1:
			pass
		#KIFE_GUN
		PickUp.PICKUP.GUN:
			Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.GUN
		PickUp.PICKUP.KNIFE:
			Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.KNIFE
		_:
			pass
	Pickup_Stats.clamp_stats()
	update_state()

func update_state()->void:
	if Pickup_Stats.LIFE_UP>=0:
		match Pickup_Stats.SPECIAL_STATE:
			PickUpStats.SPECIALSTATE.KNIFE:
				KnifeGunSprite.frame=1
				KnifeHurtBox.set_deferred("disabled",false)
			PickUpStats.SPECIALSTATE.GUN:
				KnifeGunSprite.frame=2
				KnifeHurtBox.set_deferred("disabled",true)
			_:
				KnifeGunSprite.frame=0
				KnifeHurtBox.set_deferred("disabled",true)
		if Pickup_Stats.BRICK_WALKER:
			set_collision_mask_value(4,false)
		else:
			set_collision_mask_value(4,true)
		if Pickup_Stats.KICKER:
			KickerRayCast.enabled=true
		else :
			KickerRayCast.enabled=false
	else:
		die()

func damage()->void:
	if !disabled:
		if !i_frames:
			i_frames=true
			Pickup_Stats.LIFE_UP-=1
			if Pickup_Stats.LIFE_UP<0:
				die()
			else:
				IFramesAnimation.play("i_frames")

func die()->void:
	KnifeHurtBox.set_deferred("disabled",true)
	disabled=true
	BodyAnimation.play("death")
	death_timer.start(0.6)

func place_bomb()->void:
	if Bomb_Ref_List.size()<(1+Pickup_Stats.BOMB_UP):
		bomb_place_check.enabled=true
		bomb_place_check.force_raycast_update()
		if !(bomb_place_check.is_colliding()):
			var tmp_bomb:BombBase
			match Pickup_Stats.BOMB_TYPE:
				BombList.BOMBTYPE.DEFAULT:
					tmp_bomb=BombList.Default.instantiate() as DefaultBomb
					tmp_bomb.placed_with_power=1+Pickup_Stats.FIRE_UP
				BombList.BOMBTYPE.DICE:
					tmp_bomb=BombList.Dice.instantiate() as DiceBomb
					tmp_bomb.placed_with_power=1+randi_range(0,5)
				BombList.BOMBTYPE.BANANA:
					tmp_bomb=BombList.Banana.instantiate() as BananaBomb
					(tmp_bomb as BananaBomb).placed_with_direction=get_priority_4_way_direction(current_view_direction)
				BombList.BOMBTYPE.E:
					tmp_bomb=BombList.E.instantiate() as EBomb
					(tmp_bomb as EBomb).placed_with_direction=get_priority_4_way_direction(current_view_direction)
				BombList.BOMBTYPE.PLASMA:
					tmp_bomb=BombList.Plasma.instantiate() as PlasmaBomb
					tmp_bomb.placed_with_power=1+Pickup_Stats.FIRE_UP
				BombList.BOMBTYPE.HYDROGEN:
					tmp_bomb=BombList.Hydrogen.instantiate() as HydrogenBomb
				BombList.BOMBTYPE.MINE:
					tmp_bomb=BombList.Mine.instantiate() as MineBomb
					tmp_bomb.placed_with_power=1+Pickup_Stats.FIRE_UP

				_:
					tmp_bomb=BombList.Default.instantiate()
			
			tmp_bomb.affiliated_player=self
			
			tmp_bomb.placed_with_color=Body_Color
			
			Bomb_Ref_List.append(tmp_bomb)
			map.bomb_nodes.add_child(tmp_bomb)
			tmp_bomb.position=(map.base_ground_tilemap.local_to_map(self.position)*16)+Vector2i(8,8)
		bomb_place_check.enabled=false

func fire_gun()->void:
	var view_direction_4_way:Vector2i=get_priority_4_way_direction(current_view_direction)
	Pickup_Stats.SPECIAL_STATE=PickUpStats.SPECIALSTATE.NONE
	GunRayCast.target_position=view_direction_4_way*1000
	GunRayCast.enabled=true
	GunRayCast.force_raycast_update()
	var hit_target:Object=GunRayCast.get_collider()
	GunRayCast.enabled=false
	if hit_target:
		
		var target_hit_pos:Vector2=GunRayCast.get_collision_point()
		var length:float=(target_hit_pos-global_position).length()
		var rotation_deg:float=rad_to_deg(Vector2(view_direction_4_way).angle())
		var tmp_gunshot:GunShot=gunshot.instantiate() as GunShot
		tmp_gunshot.set_color(Body_Color)
		get_parent().add_child(tmp_gunshot)
		tmp_gunshot.set_length_and_rotation(length,rotation_deg)
		tmp_gunshot.position=position+Vector2(0,-8)
		if hit_target is BrickBase:
			(hit_target as BrickBase).spawn_pickup_and_free()
		elif hit_target is BombBase:
			(hit_target as BombBase).explode()
		elif hit_target is EnemyBase:
			(hit_target as EnemyBase).damage()
		elif hit_target is PlayerCharacter:
			(hit_target as PlayerCharacter).damage()
	update_state()

func get_priority_4_way_direction(input:Vector2i)->Vector2i:
	var output:Vector2i=Vector2i.ZERO
	if input.y==0:
		output=input
	else:
		if input.x==0:
			output=input
		else:
			output.x=input.x
	return output

func get_player_state()->PlayerState:
	#TODO PLAYER ACTIONS
	var output:PlayerState = PlayerState.new()
	output.player_number=Player_Number
	output.position=global_position
	output.velocity=velocity
	output.pickup_stats=Pickup_Stats
	output.taken_aktions=[]
	return output

func _physics_process(_delta:float)->void:
	if(!disabled):
		var move_vec:Vector2i=Vector2i.ZERO
		move_vec.x+=-int(Input.is_action_pressed(Action_LEFT))+int(Input.is_action_pressed(Action_RIGHT))
		move_vec.y+=-int(Input.is_action_pressed(Action_UP))+int(Input.is_action_pressed(Action_DOWN))
		
		var animation_string:String=""
		
		if move_vec!=Vector2i.ZERO:
			current_view_direction=move_vec
			animation_string+="run_"
		else:
			animation_string+="idle_"
		
		match current_view_direction.y:
			1:
				front_back="front_"
			-1:
				front_back="back_"
			_:
				if current_view_direction.x!=0:
					front_back="front_"
		
		match current_view_direction.x:
			1:
				left_right="right"
			-1:
				left_right="left"
			_:
				pass
		
		KickerRayCast.rotation=Vector2(get_priority_4_way_direction(current_view_direction)).angle()-0.5*PI
		var kicker_target:Object=KickerRayCast.get_collider()
		if kicker_target&&kicker_target is BombBase:
			print("HIT SOMETHING POGGERS")
			if (kicker_target as BombBase).kickable:
				var direction:Vector2=Vector2((kicker_target as Node2D).global_position-KickerRayCast.get_collision_point())
				#direction=direction.normalized()
				
				var direction_i:Vector2i=Vector2i.ZERO
				if abs(direction.x)>=abs(direction.y):
					direction_i.x=roundi(signf(direction.x))
				else:
					direction_i.y=roundi(signf(direction.y))
				print(direction_i)
				#(kicker_target as BombBase).kick(get_priority_4_way_direction(current_view_direction))
				#print(direction_i)
				(kicker_target as BombBase).kick(direction_i)
		
		BodyAnimation.play(animation_string+front_back+left_right)
		var normalized_move_vec:Vector2=Vector2(move_vec).normalized()
		velocity=normalized_move_vec*BASE_MOVEMENT_SPEED*(Pickup_Stats.get_speed_scale())
		move_and_slide()
		
		if Input.is_action_just_pressed(Action_0):
			place_bomb()
		if Input.is_action_just_pressed(Action_1):
			match Pickup_Stats.SPECIAL_STATE:
				PickUpStats.SPECIALSTATE.GUN:
					fire_gun()
				_:
					pass

func _ready()->void:
	update_state()

func _on_kife_dmg_area_body_entered(body:Node2D)->void:
	if body!=self:
		if body is PlayerCharacter:
			if !((body as PlayerCharacter).i_frames):
				if !((body as PlayerCharacter).disabled):
					(body as PlayerCharacter).damage()
					Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.NONE
					update_state()

func _on_i_frames_animation_animation_finished(_anim_name:String)->void:
	i_frames=false

func _on_death_timer_timeout()->void:
	map.player_ref_list.erase(self)
	map.check_winner()
	queue_free()
