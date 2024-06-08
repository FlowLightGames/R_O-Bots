extends Control
class_name LobbyCharacterCustom

@export var type:int
@export var disabled:bool=false
@export var player_tag:Label
@export var example_character_0:PlayerCharacter
@export var example_character_1:PlayerCharacter
@export var example_character_2:PlayerCharacter
@export var example_character_3:PlayerCharacter

@export var panel_content:Control
@export var ready_overlay:Control
@export var player_name:Control
@export var lobby_ref:MultiplayerCustomLobby
@export var gamepad_cursor:GamepadCharacterCustomCursor

@export var body_color_txt:Label
@export var body_txt:Label
@export var face_color_txt:Label
@export var face_custom_txt:Label
@export var face_number_txt:Label

var player_ready:bool=false

var max_number_body_color:int=8
var max_number_body_base:int=6
var max_number_face_color:int=8
var max_number_face_base:int=0

var current_body_base:int=0
var current_body_color:int=0

var current_face_base:int=0
var current_face_color:int=0
var current_face_custom:bool=false

func _ready()->void:
	(material as ShaderMaterial).set_shader_parameter("Type",type)
	gamepad_cursor.assigned_player=type
	
	example_character_0.BodyAnimation.play("idle_front_left")
	example_character_1.BodyAnimation.play("idle_front_right")
	example_character_2.BodyAnimation.play("run_front_left")
	example_character_3.BodyAnimation.play("run_front_right")
	
	example_character_0.set_new_body_color(type)
	example_character_1.set_new_body_color(type)
	example_character_2.set_new_body_color(type)
	example_character_3.set_new_body_color(type)
	example_character_0.set_new_face(FacesAutoload.preset_faces[0])
	example_character_1.set_new_face(FacesAutoload.preset_faces[0])
	example_character_2.set_new_face(FacesAutoload.preset_faces[0])
	example_character_3.set_new_face(FacesAutoload.preset_faces[0])
	example_character_0.set_new_face_color(type)
	example_character_1.set_new_face_color(type)
	example_character_2.set_new_face_color(type)
	example_character_3.set_new_face_color(type)
	
	current_body_color=type
	current_face_color=type
	
	body_color_txt.text=str(current_body_color)
	face_color_txt.text=str(current_face_color)
	
	player_tag.text="Player"+str(type)
	
	example_character_0.Player_Number=type
	example_character_1.Player_Number=type
	example_character_2.Player_Number=type
	example_character_3.Player_Number=type
	
	example_character_0.set_player_name("Player"+str(type))
	example_character_1.set_player_name("Player"+str(type))
	example_character_2.set_player_name("Player"+str(type))
	example_character_3.set_player_name("Player"+str(type))
	
	max_number_face_base=FacesAutoload.preset_faces.size()
	
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_LOBBY:
		if type!=SteamLobby.player_number:
			disabled=true

func _physics_process(delta:float)->void:
	if Input.is_action_just_pressed(str(type)+"_Action_0"):
			set_ready()
	if Input.is_action_just_pressed(str(type)+"_Action_0"):
			if player_ready:
				unset_ready()

func enable()->void:
	#_ready()
	panel_content.visible=true
	player_name.visible=true
	gamepad_cursor.enable()
func disable()->void:
	panel_content.visible=false
	player_name.visible=false
	gamepad_cursor.disable()


func update_to_player_config(player_number:int)->void:
	var config:PlayerConfigMetaData=PlayerConfigs.Player_Configs[player_number]
	
	current_body_color=config.Body_Color
	example_character_0.set_new_body_color(current_body_color)
	example_character_1.set_new_body_color(current_body_color)
	body_color_txt.text=str(current_body_color)
	
	current_body_base=config.Body_Base
	example_character_0.set_new_body(current_body_base)
	example_character_1.set_new_body(current_body_base)
	body_txt.text=str(current_body_base)
	
	current_face_color=config.Face_Color
	example_character_0.set_new_face_color(current_face_color)
	example_character_1.set_new_face_color(current_face_color)
	face_color_txt.text=str(current_face_color)
	
	current_face_base=config.Face_Base
	current_face_custom=config.Custom_Face
	if current_face_custom:
		if current_face_base>=0&&current_face_base<config.custom_faces.size():
			example_character_0.set_new_face(config.custom_faces[current_face_base])
			example_character_1.set_new_face(config.custom_faces[current_face_base])
	else:
		example_character_0.set_new_face(FacesAutoload.preset_faces[current_face_base])
		example_character_1.set_new_face(FacesAutoload.preset_faces[current_face_base])
	face_number_txt.text=str(current_face_base)

func update_body_color()->void:
	example_character_0.set_new_body_color(current_body_color)
	example_character_1.set_new_body_color(current_body_color)
	body_color_txt.text=str(current_body_color)

func _on_bodycolor_dec_pressed()->void:
	if(!disabled):
		current_body_color=posmod(current_body_color-1,max_number_body_color)
		update_body_color()
		send_character_custom_update()

func _on_bodycolor_inc_pressed()->void:
	if(!disabled):
		current_body_color=posmod(current_body_color+1,max_number_body_color)
		update_body_color()
		send_character_custom_update()

func update_body_type()->void:
	example_character_0.set_new_body(current_body_base)
	example_character_1.set_new_body(current_body_base)
	body_txt.text=str(current_body_base)

func _on_bodytype_dec_pressed()->void:
	if(!disabled):
		current_body_base=posmod(current_body_base-1,max_number_body_base)
		update_body_type()
		send_character_custom_update()

func _on_bodytype_inc_pressed()->void:
	if(!disabled):
		current_body_base=posmod(current_body_base+1,max_number_body_base)
		update_body_type()
		send_character_custom_update()

func update_face_color()->void:
	example_character_0.set_new_face_color(current_face_color)
	example_character_1.set_new_face_color(current_face_color)
	face_color_txt.text=str(current_face_color)

func _on_facecolor_dec_pressed()->void:
	if(!disabled):
		current_face_color=posmod(current_face_color-1,max_number_face_color)
		update_face_color()
		send_character_custom_update()

func _on_facecolor_inc_pressed()->void:
	if(!disabled):
		current_face_color=posmod(current_face_color+1,max_number_face_color)
		update_face_color()
		send_character_custom_update()

func update_face_type()->void:
	if current_face_custom:
		#print(PlayerConfigs.Player_Configs[type].serialize())
		#print(FacesAutoload.custom_faces.size())
		#print(PlayerConfigs.Player_Configs[type].custom_faces.size())
		if current_face_base>=0&&current_face_base<PlayerConfigs.Player_Configs[type].custom_faces.size():
			example_character_0.set_new_face(PlayerConfigs.Player_Configs[type].custom_faces[current_face_base])
			example_character_1.set_new_face(PlayerConfigs.Player_Configs[type].custom_faces[current_face_base])
		else:
			current_face_base=0
			example_character_0.set_new_face(null)
			example_character_1.set_new_face(null)
	else:
		example_character_0.set_new_face(FacesAutoload.preset_faces[current_face_base])
		example_character_1.set_new_face(FacesAutoload.preset_faces[current_face_base])
	face_number_txt.text=str(current_face_base)

func _on_facetype_dec_pressed()->void:
	if(!disabled):
		current_face_base=posmod(current_face_base-1,max_number_face_base)
		update_face_type()
		send_character_custom_update()

func _on_facetype_inc_pressed()->void:
	if(!disabled):
		current_face_base=posmod(current_face_base+1,max_number_face_base)
		update_face_type()
		send_character_custom_update()

func update_face_custom()->void:
	if current_face_custom:
		max_number_face_base=maxi(PlayerConfigs.Player_Configs[type].custom_faces.size(),1)
		face_custom_txt.text="CSTM"
		if PlayerConfigs.Player_Configs[type].custom_faces.is_empty():
			example_character_0.set_new_face(null)
			example_character_1.set_new_face(null)
		else:
			example_character_0.set_new_face(PlayerConfigs.Player_Configs[type].custom_faces[0])
			example_character_1.set_new_face(PlayerConfigs.Player_Configs[type].custom_faces[0])
	else:
		max_number_face_base=FacesAutoload.preset_faces.size()
		face_custom_txt.text="DEF"
		example_character_0.set_new_face(FacesAutoload.preset_faces[0])
		example_character_1.set_new_face(FacesAutoload.preset_faces[0])
	face_number_txt.text=str(current_face_base)

func _on_facepreset_dec_pressed()->void:
	if(!disabled):
		current_face_base=0
		current_face_custom=!current_face_custom
		update_face_custom()
		send_character_custom_update()

func _on_facepreset_inc_pressed()->void:
	if(!disabled):
		current_face_base=0
		current_face_custom=!current_face_custom
		update_face_custom()
		send_character_custom_update()

func unset_ready()->void:
	enable()
	player_ready=false
	ready_overlay.visible=false

func set_ready()->void:
	example_character_2.set_new_body(current_body_base)
	example_character_3.set_new_body(current_body_base)
	example_character_2.set_new_body_color(current_body_color)
	example_character_3.set_new_body_color(current_body_color)
	example_character_2.set_new_face_color(current_face_color)
	example_character_3.set_new_face_color(current_face_color)
	
	if current_face_custom:
		if !FacesAutoload.custom_faces.is_empty():
			example_character_2.set_new_face(FacesAutoload.custom_faces[current_face_base])
			example_character_3.set_new_face(FacesAutoload.custom_faces[current_face_base])
		else:
			example_character_2.set_new_face(null)
			example_character_3.set_new_face(null)
	else:
		example_character_2.set_new_face(FacesAutoload.preset_faces[current_face_base])
		example_character_3.set_new_face(FacesAutoload.preset_faces[current_face_base])
	
	disable()
	player_ready=true
	ready_overlay.visible=true

func _on_ready_pressed()->void:
	if (!disabled):
		set_ready()
		send_character_custom_finished()

func send_character_custom_finished()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_LOBBY:
		if SteamLobby.player_number==type:
			#body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,self_player_number:int
			var msg:PackedByteArray=PackageConstructor.character_data_update(
				current_body_base,
				current_body_color,
				current_face_base,
				current_face_color,
				current_face_custom,
				SteamLobby.player_number,
				true)
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,msg)

func send_character_custom_update()->void:
	if MultiplayerStatus.Current_Status==MultiplayerStatus.STATE.ONLINE_LOBBY:
		if SteamLobby.player_number==type:
			#body_base:int,body_color:int,face_base:int,face_color:int,face_custom:bool,self_player_number:int
			var msg:PackedByteArray=PackageConstructor.character_data_update(
				current_body_base,
				current_body_color,
				current_face_base,
				current_face_color,
				current_face_custom,
				SteamLobby.player_number,
				false)
			SteamLobby.send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,msg)

func apply_character_custom_update(ready_check:bool,face_custom:bool,input:Array[int])->void:
	current_body_base=input[0]
	current_body_color=input[1]
	current_face_base=input[2]
	current_face_color=input[3]
	
	current_face_custom=face_custom
	#do this forst for later setting face base
	update_face_custom()
	
	update_body_type()
	update_body_color()
	update_face_type()
	update_face_color()
	
	if ready_check:
		set_ready()
