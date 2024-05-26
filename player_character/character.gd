extends CharacterBody2D

class_name PlayerCharacter

enum TAKEN_ACTION{
	ZEUS,
	GUN,
	PLACE_BOMB,
	DETONATE_BOMB
	}

var gunshot:PackedScene=load("res://player_character/gun_knife/gun_shot.tscn") as PackedScene
var zeus_lightning:PackedScene=load("res://player_character/zeus/zeus_lightning.tscn") as PackedScene
var fart:PackedScene=load("res://player_character/fart/fart.tscn") as PackedScene
var fire_ball:PackedScene=load("res://player_character/fire/fire_ball.tscn") as PackedScene

@export var name_label:Label
@export var BodyAnimation:AnimationPlayer
@export var FaceAnimation:AnimationPlayer
@export var IFramesAnimation:AnimationPlayer
@export var Face:Sprite2D
@export var Body:Sprite2D
@export var bomb_place_check:RayCast2D
@export var KnifeGunSprite:Sprite2D
@export var ZeusReticle:Node2D
@export var KnifeHurtBox:CollisionShape2D
@export var GunRayCast:RayCast2D
@export var KickerRayCast:RayCast2D
@export var DunkerRayCast:RayCast2D
#TIMERS
@export var fart_timer:Timer
@export var fire_timer:Timer
@export var death_timer:Timer
#AUDIO
@export var gunshot_audio:AudioStreamPlayer
@export var knifeshiv_audio:AudioStreamPlayer

var i_frames:bool=false
@export var disabled:bool=false
#for multiplayer so we dont control other players
var is_puppet:bool=false
var moving:bool=false
var flagged_for_sync:bool=false

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

func set_player_name(to:String)->void:
	Player_Name=to
	name_label.text=Player_Name
	(name_label.material as ShaderMaterial).set_shader_parameter("Type",Player_Number)

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

func input_map_init()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		Action_UP ="0_Up"
		Action_DOWN ="0_Down"
		Action_LEFT ="0_Left"
		Action_RIGHT ="0_Right"
		Action_0 ="0_Action_0"
		Action_1 ="0_Action_1"
	else:
		Action_UP =str(Player_Number)+"_Up"
		Action_DOWN =str(Player_Number)+"_Down"
		Action_LEFT =str(Player_Number)+"_Left"
		Action_RIGHT =str(Player_Number)+"_Right"
		Action_0 =str(Player_Number)+"_Action_0"
		Action_1 =str(Player_Number)+"_Action_1"

func disable()->void:
	disabled=true
	fart_timer.stop()
	fire_timer.stop()
	death_timer.stop()

func enable()->void:
	#TODO start timers if we have the pickup[[
	update_state()
	moving=false
	disabled=false

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
			Pickup_Stats.BOMB_UP+=16
		PickUp.PICKUP.SPEED_MAX:
			Pickup_Stats.SPEED_UP+=10
		#BALLS
		PickUp.PICKUP.KICKER:
			Pickup_Stats.KICKER=true
		PickUp.PICKUP.DUNKER:
			Pickup_Stats.DUNKER=true
		PickUp.PICKUP.BRICK_WALKER:
			Pickup_Stats.BRICK_WALKER=true
		#SPECIAL YET
		PickUp.PICKUP.PILL:
			var possible_pickups:Array=PickUp.PICKUP.values()
			possible_pickups.erase(int(PickUp.PICKUP.PILL))
			var picked:int=possible_pickups.pick_random() as int
			print(PickUp.PICKUP.find_key(picked))
			picked_up(picked)
		PickUp.PICKUP.POOP:
			Pickup_Stats.add_state(PickUpStats.STATE.POOP)
		PickUp.PICKUP.FIRE:
			Pickup_Stats.add_state(PickUpStats.STATE.FIRE)
		PickUp.PICKUP.FART:
			Pickup_Stats.add_state(PickUpStats.STATE.FART)
		#KIFE_GUN
		PickUp.PICKUP.GUN:
			Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.GUN
		PickUp.PICKUP.KNIFE:
			Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.KNIFE
		PickUp.PICKUP.ZEUS:
			Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.ZEUS
		_:
			pass
	Pickup_Stats.clamp_stats()
	update_state()
	send_taken_action(PlayerState.ACTIONS.NOTHING)

func update_state()->void:
	if Pickup_Stats.LIFE_UP>=0:
		match Pickup_Stats.SPECIAL_STATE:
			PickUpStats.SPECIALSTATE.KNIFE:
				ZeusReticle.visible=false
				KnifeGunSprite.frame=1
				KnifeHurtBox.set_deferred("disabled",false)
			PickUpStats.SPECIALSTATE.GUN:
				ZeusReticle.visible=false
				KnifeGunSprite.frame=2
				KnifeHurtBox.set_deferred("disabled",true)
			PickUpStats.SPECIALSTATE.ZEUS:
				ZeusReticle.position=position
				ZeusReticle.visible=true
				KnifeGunSprite.frame=0
				KnifeHurtBox.set_deferred("disabled",true)
			_:
				ZeusReticle.position=position
				ZeusReticle.visible=false
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
		if Pickup_Stats.STATES[0]>0:
			bomb_place_check.enabled=true
		else:
			bomb_place_check.enabled=false
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
	if !disabled:
		KnifeHurtBox.set_deferred("disabled",true)
		disabled=true
		BodyAnimation.play("death")
		death_timer.start(0.6)

func action_one()->void:
	bomb_place_check.force_raycast_update()
	if !(bomb_place_check.is_colliding()):
		place_bomb()
	else:
		throw_bomb()

func action_two()->void:
	detonate_bomb()
	match Pickup_Stats.SPECIAL_STATE:
				PickUpStats.SPECIALSTATE.GUN:
					fire_gun()
					send_taken_action(PlayerState.ACTIONS.GUN_FIRED)
				_:
					pass

func place_bomb()->void:
	if Bomb_Ref_List.size()<(1+Pickup_Stats.BOMB_UP):
		var tmp_bomb:BombBase
		match Pickup_Stats.BOMB_TYPE:
			BombList.BOMBTYPE.DEFAULT:
				tmp_bomb=BombList.Default.instantiate() as DefaultBomb
				tmp_bomb.placed_with_power=1+Pickup_Stats.FIRE_UP
			BombList.BOMBTYPE.REMOTE:
				tmp_bomb=BombList.Remote.instantiate() as RemoteBomb
				tmp_bomb.placed_with_power=1+Pickup_Stats.FIRE_UP
			BombList.BOMBTYPE.DICE:
				tmp_bomb=BombList.Dice.instantiate() as DiceBomb
				tmp_bomb.placed_with_power=1+randi_range(0,5)
			BombList.BOMBTYPE.BANANA:
				tmp_bomb=BombList.Banana.instantiate() as BananaBomb
				tmp_bomb.placed_with_direction=get_priority_4_way_direction(current_view_direction)
			BombList.BOMBTYPE.E:
				tmp_bomb=BombList.E.instantiate() as EBomb
				tmp_bomb.placed_with_direction=get_priority_4_way_direction(current_view_direction)
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
		tmp_bomb.affiliated_map=map
		
		tmp_bomb.placed_with_color=Body_Color
		
		Bomb_Ref_List.append(tmp_bomb)
		tmp_bomb.position=(map.base_ground_tilemap.local_to_map(self.position)*16)+Vector2i(8,8)
		map.bomb_nodes.add_child(tmp_bomb)
		
		send_taken_action(PlayerState.ACTIONS.BOMB_PLACED)

func fire_lightning()->void:
	var tmp:ZeusLightning=zeus_lightning.instantiate() as ZeusLightning
	tmp.global_position=ZeusReticle.global_position
	tmp.set_color(Body_Color)
	get_parent().add_child(tmp)

func detonate_bomb()->void:
	for n:BombBase in Bomb_Ref_List:
		if n is RemoteBomb:
			(n as RemoteBomb).explode()
			send_taken_action(PlayerState.ACTIONS.BOMB_DETONATE)
			break

func throw_bomb()->void:
	if Pickup_Stats.DUNKER:
		DunkerRayCast.force_raycast_update()
		if (DunkerRayCast.is_colliding()):
			var throwable_bomb:BombBase=DunkerRayCast.get_collider() as BombBase
			if throwable_bomb:
				if throwable_bomb.throwable:
					throwable_bomb.throw(get_priority_4_way_direction(current_view_direction))
					send_taken_action(PlayerState.ACTIONS.BOMB_THROW)

func fire_gun()->void:
	var view_direction_4_way:Vector2i=get_priority_4_way_direction(current_view_direction)
	Pickup_Stats.SPECIAL_STATE=PickUpStats.SPECIALSTATE.NONE
	GunRayCast.target_position=view_direction_4_way*1000
	GunRayCast.force_raycast_update()
	var hit_target:Object=GunRayCast.get_collider()
	if hit_target:
		
		var target_hit_pos:Vector2=GunRayCast.get_collision_point()
		var length:float=(target_hit_pos-global_position).length()
		var rotation_deg:float=rad_to_deg(Vector2(view_direction_4_way).angle())
		var tmp_gunshot:GunShot=gunshot.instantiate() as GunShot
		tmp_gunshot.set_color(Body_Color)
		get_parent().add_child(tmp_gunshot)
		tmp_gunshot.set_length_and_rotation(length,rotation_deg)
		tmp_gunshot.position=position+Vector2(0,-8)
		gunshot_audio.play(0.0)
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
	var output:PlayerState = PlayerState.new()
	output.player_number=Player_Number
	if velocity.x !=0.0||velocity.y!=0.0:
		output.moving=true
	output.dead=false
	output.position=global_position
	output.reticle_position=ZeusReticle.global_position
	output.direction=current_view_direction
	output.pickup_stats=Pickup_Stats
	output.taken_action=PlayerState.ACTIONS.NOTHING
	return output

func apply_player_state(player_state:PlayerState)->void:
	global_position=player_state.position
	ZeusReticle.global_position=player_state.reticle_position
	Pickup_Stats=player_state.pickup_stats
	current_view_direction=player_state.direction
	moving=player_state.moving
	update_state()
	
	match player_state.taken_action:
		PlayerState.ACTIONS.NOTHING:
			pass
		PlayerState.ACTIONS.BOMB_PLACED:
			place_bomb()
		PlayerState.ACTIONS.BOMB_THROW:
			pass
		PlayerState.ACTIONS.BOMB_DETONATE:
			pass
		PlayerState.ACTIONS.GUN_FIRED:
			pass
		PlayerState.ACTIONS.ZEUS_FIRED:
			pass
		_:
			pass

func handle_passive_actions()->void:
	KickerRayCast.rotation=Vector2(get_priority_4_way_direction(current_view_direction)).angle()-0.5*PI
	var kicker_target:Object=KickerRayCast.get_collider()
	if kicker_target&&kicker_target is BombBase:
		#print("HIT SOMETHING POGGERS")
		if (kicker_target as BombBase).kickable:
			var direction:Vector2=Vector2((kicker_target as Node2D).global_position-KickerRayCast.get_collision_point())
			#direction=direction.normalized()
			
			var direction_i:Vector2i=Vector2i.ZERO
			if abs(direction.x)>=abs(direction.y):
				direction_i.x=roundi(signf(direction.x))
			else:
				direction_i.y=roundi(signf(direction.y))
			#print(direction_i)
			#(kicker_target as BombBase).kick(get_priority_4_way_direction(current_view_direction))
			#print(direction_i)
			(kicker_target as BombBase).kick(direction_i)
	#Pooping
	if Pickup_Stats.STATES[0]>0:
		if !(bomb_place_check.is_colliding()):
			place_bomb()
	#Fire ing
	if Pickup_Stats.STATES[1]>0:
		if fire_timer.is_stopped():
			fire_timer.start(1.5)
	#Farting
	if Pickup_Stats.STATES[2]>0:
		if fart_timer.is_stopped():
			fart_timer.start(2.0)

func send_taken_action(input:PlayerState.ACTIONS)->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_MULTIPLAYER:
		if SteamLobby.is_host:
			var player_state:PlayerState=get_player_state()
			player_state.taken_action=input
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_UNRELIABLE,PackageConstructor.player_state_update(player_state,GlobalSteam.steam_id))
			#TODO send the thing
		else:
			#TODO HOST CASE
			var player_state:PlayerState=get_player_state()
			player_state.taken_action=input
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_UNRELIABLE,PackageConstructor.player_state_update(player_state,GlobalSteam.steam_id))

func _physics_process(_delta:float)->void:
	if !disabled:
		#if this is your PC
		if !is_puppet:
			flagged_for_sync=false
			if Pickup_Stats.SPECIAL_STATE==PickUpStats.SPECIALSTATE.ZEUS:
				BodyAnimation.play("zeus")
				var move_vec:Vector2i=Vector2i.ZERO
				move_vec.x+=-int(Input.is_action_pressed(Action_LEFT))+int(Input.is_action_pressed(Action_RIGHT))
				move_vec.y+=-int(Input.is_action_pressed(Action_UP))+int(Input.is_action_pressed(Action_DOWN))
				ZeusReticle.position=ZeusReticle.position+_delta*move_vec*60
				
				if Input.is_action_just_pressed(Action_1):
					fire_lightning()
					send_taken_action(PlayerState.ACTIONS.ZEUS_FIRED)
					Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.NONE
					
					ZeusReticle.visible=false
					ZeusReticle.position=Vector2.ZERO
			else:
				var move_vec:Vector2i=Vector2i.ZERO
				move_vec.x+=-int(Input.is_action_pressed(Action_LEFT))+int(Input.is_action_pressed(Action_RIGHT))
				move_vec.y+=-int(Input.is_action_pressed(Action_UP))+int(Input.is_action_pressed(Action_DOWN))
				
				var animation_string:String=""
				var tmp_moving:bool=false
				if move_vec!=Vector2i.ZERO:
					tmp_moving=true
					current_view_direction=move_vec
					animation_string+="run_"
				else:
					animation_string+="idle_"
					tmp_moving=false
				
				if tmp_moving!=moving:
					flagged_for_sync=true
				moving=tmp_moving
				
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
				
				BodyAnimation.play(animation_string+front_back+left_right)
				var normalized_move_vec:Vector2=Vector2(move_vec).normalized()
				velocity=normalized_move_vec*BASE_MOVEMENT_SPEED*(Pickup_Stats.get_speed_scale())
				move_and_slide()
				
				handle_passive_actions()
				
				if Input.is_action_just_pressed(Action_0):
					action_one()
				if Input.is_action_just_pressed(Action_1):
					action_two()
				
				if flagged_for_sync:
					flagged_for_sync=false
					send_taken_action(PlayerState.ACTIONS.NOTHING)
		#if were someone elses PC (puppet)
		else:
			if Pickup_Stats.SPECIAL_STATE==PickUpStats.SPECIALSTATE.ZEUS:
				BodyAnimation.play("zeus")
			else:
				
				var animation_string:String=""
				if moving==true:
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
				
				BodyAnimation.play(animation_string+front_back+left_right)
				if moving:
					var normalized_move_vec:Vector2=Vector2(current_view_direction).normalized()
					velocity=normalized_move_vec*BASE_MOVEMENT_SPEED*(Pickup_Stats.get_speed_scale())
					move_and_slide()
				
				handle_passive_actions()

func _ready()->void:
	update_state()

func _on_kife_dmg_area_body_entered(body:Node2D)->void:
	if body!=self:
		if body is PlayerCharacter:
			if !((body as PlayerCharacter).i_frames):
				if !((body as PlayerCharacter).disabled):
					knifeshiv_audio.play(0.0)
					(body as PlayerCharacter).damage()
					Pickup_Stats.SPECIAL_STATE=Pickup_Stats.SPECIALSTATE.NONE
					update_state()

func _on_i_frames_animation_animation_finished(_anim_name:String)->void:
	i_frames=false

func _on_death_timer_timeout()->void:
	map.player_ref_list.erase(self)
	map.check_winner()
	queue_free()

func _on_fart_timer_timeout()->void:
	var tmp:Fart=fart.instantiate() as Fart
	tmp.position=position
	tmp.ignored_bodies.append(self)
	get_parent().add_child(tmp)

func _on_fire_timer_timeout()->void:
	var tmp:FireBall=fire_ball.instantiate() as FireBall
	tmp.position=position
	tmp.direction=get_priority_4_way_direction(current_view_direction)
	tmp.ignored_bodies.append(self)
	get_parent().add_child(tmp)
