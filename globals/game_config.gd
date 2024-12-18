extends Node

#Version of current exe
var game_version:String=""

#Audio Settings
var Master:int=100
var Music:int=50
var SFX:int=50

#Video Settings
var Resolution:Vector2i=Vector2i(1920,1080)
var CRT_Filer:bool=false
var Fullscreen:bool=false

#SAVE/LOAD
var save_path:String="user://R_O-Bots_Config.save"

var Max_Players:int=8
var Player_Input_Dicts:Array[Dictionary]=[{},{},{},{},{},{},{},{}]

func _ready()->void:
	load_data()
	game_version=ProjectSettings.get_setting("application/config/version")

func apply_video_settings()->void:
	var window:Window=get_window()
	window.borderless=true
	window.size=Resolution
	#DisplayServer.window_set_size(Resolution)
	if Fullscreen:
		window.mode=Window.MODE_EXCLUSIVE_FULLSCREEN
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		window.mode=Window.MODE_WINDOWED
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	window.move_to_center()
	#TODO CRT FILTER
	if CRT_Filer:
		CrtOverlay.visible=true
	else:
		CrtOverlay.visible=false

func apply_audio_settings()->void:
	AudioServer.set_bus_volume_db(0,linear_to_db(float(Master)/100.0))
	AudioServer.set_bus_volume_db(1,linear_to_db(float(Music)/100.0))
	AudioServer.set_bus_volume_db(2,linear_to_db(float(SFX)/100.0))

func load_player_input_dicts()->void:
	var curr_handled_player_num:int=0
	for n:Dictionary in Player_Input_Dicts:
		for action:String in n:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action,get_input_event(n[action]))
			Player_Input_Dicts[curr_handled_player_num][action]=n[action]
		curr_handled_player_num+=1

func create_def_input_map()->void:
	for n:int in range(0,Max_Players):
		create_def_input_map_player(n)

func create_def_input_map_player(curr_handled_player_num:int)->void:
	var output:Dictionary= {}
	if !InputMap.has_action(str(curr_handled_player_num)+"_Up"):
		InputMap.add_action(str(curr_handled_player_num)+"_Up")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Up")
	var ev:InputEventKey = InputEventKey.new()
	ev.physical_keycode = KEY_W
	InputMap.action_add_event(str(curr_handled_player_num)+"_Up", ev)
	
	output[str(curr_handled_player_num)+"_Up"]=get_input_code(ev)
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Left"):
		InputMap.add_action(str(curr_handled_player_num)+"_Left")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Left")
	ev = InputEventKey.new()
	ev.physical_keycode = KEY_A
	InputMap.action_add_event(str(curr_handled_player_num)+"_Left", ev)
	
	output[str(curr_handled_player_num)+"_Left"]=get_input_code(ev)
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Down"):
		InputMap.add_action(str(curr_handled_player_num)+"_Down")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Down")
	ev = InputEventKey.new()
	ev.physical_keycode = KEY_S
	InputMap.action_add_event(str(curr_handled_player_num)+"_Down", ev)
	
	output[str(curr_handled_player_num)+"_Down"]=get_input_code(ev)
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Right"):
		InputMap.add_action(str(curr_handled_player_num)+"_Right")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Right")
	ev = InputEventKey.new()
	ev.physical_keycode = KEY_D
	InputMap.action_add_event(str(curr_handled_player_num)+"_Right", ev)
	
	output[str(curr_handled_player_num)+"_Right"]=get_input_code(ev)
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Action_0"):
		InputMap.add_action(str(curr_handled_player_num)+"_Action_0")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Action_0")
	ev= InputEventKey.new()
	ev.physical_keycode = KEY_SPACE
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_0", ev)
	
	output[str(curr_handled_player_num)+"_Action_0"]=get_input_code(ev)
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Action_1"):
		InputMap.add_action(str(curr_handled_player_num)+"_Action_1")
	InputMap.action_erase_events(str(curr_handled_player_num)+"_Action_1")
	ev= InputEventKey.new()
	ev.physical_keycode = KEY_B
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_1", ev)
	
	output[str(curr_handled_player_num)+"_Action_1"]=get_input_code(ev)
	
	Player_Input_Dicts[curr_handled_player_num]=output

func get_new_input_event_button(device:int,id:JoyButton)->InputEvent:
	var inputevent:InputEventJoypadButton=InputEventJoypadButton.new()
	inputevent.device=device
	inputevent.button_index=id
	return inputevent

func get_new_input_event_axis(device:int,axis:JoyAxis,value:float)->InputEvent:
	var inputevent:InputEventJoypadMotion=InputEventJoypadMotion.new()
	inputevent.device=device
	inputevent.axis=axis
	inputevent.axis_value=value
	return inputevent

func add_gamepad_input(curr_handled_player_num:int)->void:
	#var button_event:InputEventJoypadButton=InputEventJoypadButton.new()
	#var stick_event:InputEventJoypadMotion=InputEventJoypadMotion.new()
	#
	#button_event.device=curr_handled_player_num
	#stick_event.device=curr_handled_player_num
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Up"):
		InputMap.add_action(str(curr_handled_player_num)+"_Up")
	
	#button_event.button_index=JOY_BUTTON_DPAD_UP
	#stick_event.axis=JOY_AXIS_LEFT_Y
	#stick_event.axis_value=-1.0
	
	InputMap.action_add_event(str(curr_handled_player_num)+"_Up",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_DPAD_UP))
	InputMap.action_add_event(str(curr_handled_player_num)+"_Up",get_new_input_event_axis(curr_handled_player_num,JOY_AXIS_LEFT_Y,-1.0))
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Down"):
		InputMap.add_action(str(curr_handled_player_num)+"_Down")
	
	#button_event.button_index=JOY_BUTTON_DPAD_DOWN
	#stick_event.axis=JOY_AXIS_LEFT_Y
	#stick_event.axis_value=1.0
	
	InputMap.action_add_event(str(curr_handled_player_num)+"_Down",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_DPAD_DOWN))
	InputMap.action_add_event(str(curr_handled_player_num)+"_Down",get_new_input_event_axis(curr_handled_player_num,JOY_AXIS_LEFT_Y,1.0))
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Left"):
		InputMap.add_action(str(curr_handled_player_num)+"_Left")
	
	#button_event.button_index=JOY_BUTTON_DPAD_LEFT
	#stick_event.axis=JOY_AXIS_LEFT_X
	#stick_event.axis_value=-1.0
	
	InputMap.action_add_event(str(curr_handled_player_num)+"_Left",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_DPAD_LEFT))
	InputMap.action_add_event(str(curr_handled_player_num)+"_Left",get_new_input_event_axis(curr_handled_player_num,JOY_AXIS_LEFT_X,-1.0))
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Right"):
		InputMap.add_action(str(curr_handled_player_num)+"_Right")
	
	#button_event.button_index=JOY_BUTTON_DPAD_RIGHT
	#stick_event.axis=JOY_AXIS_LEFT_X
	#stick_event.axis_value=1.0
	
	InputMap.action_add_event(str(curr_handled_player_num)+"_Right",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_DPAD_RIGHT))
	InputMap.action_add_event(str(curr_handled_player_num)+"_Right",get_new_input_event_axis(curr_handled_player_num,JOY_AXIS_LEFT_X,1.0))
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Action_0"):
		InputMap.add_action(str(curr_handled_player_num)+"_Action_0")
	
	#button_event.button_index=JOY_BUTTON_A
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_0",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_A))
	#button_event.button_index=JOY_BUTTON_B
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_0",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_B))
	
	if !InputMap.has_action(str(curr_handled_player_num)+"_Action_1"):
		InputMap.add_action(str(curr_handled_player_num)+"_Action_1")
	
	#button_event.button_index=JOY_BUTTON_X
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_1",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_X))
	#button_event.button_index=JOY_BUTTON_Y
	InputMap.action_add_event(str(curr_handled_player_num)+"_Action_1",get_new_input_event_button(curr_handled_player_num,JOY_BUTTON_Y))

func get_input_code(event:InputEvent)->String:
	if event:
		if event is InputEventKey:
			return str(int((event as InputEventKey).physical_keycode))
		elif event is InputEventMouseButton:
			return "M_"+str((event as InputEventMouseButton).button_index)
		else:
			return ""
	else:
		return ""

func get_input_event(code:String)->InputEvent:
	var check:PackedStringArray=code.split("_")
	if check.is_empty():
		return null
	else:
		if check[0]=="M":
			var mouse:InputEventMouseButton=InputEventMouseButton.new()
			mouse.button_index=int(check[1])
			return mouse
		else:
			var key:InputEventKey=InputEventKey.new()
			key.physical_keycode=int(check[0]) as Key
			return key

func save_data()->void:
	var save_dict:Dictionary={}
	save_dict["Version"]=ProjectSettings.get_setting("application/config/version")
	
	save_dict["Master"]=Master
	save_dict["Music"]=Music
	save_dict["SFX"]=SFX
	
	save_dict["Res"]=Resolution
	save_dict["CRT"]=CRT_Filer
	save_dict["Fullscreen"]=Fullscreen
	
	save_dict["Input"]=Player_Input_Dicts
	
	var custom_faces:Array[PackedByteArray]=[]
	for n:Texture2D in FacesAutoload.custom_faces:
		custom_faces.append(FacesAutoload.face_to_bytes(n))
	
	save_dict["CstmFcs"]=custom_faces
	
	var file:FileAccess=FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()

func load_data()->void:
	if FileAccess.file_exists(save_path):
		var file:FileAccess=FileAccess.open(save_path,FileAccess.READ)
		var load_dict:Dictionary=file.get_var()
		
		var check_version:String="NO_VERSION"
		
		if load_dict.has("Version"):
			check_version=load_dict["Version"]
		
		if check_version!=game_version:
			#TODO
			#Save Version!= Game version
			pass
		
		Master=load_dict["Master"]
		Music=load_dict["Music"]
		SFX=load_dict["SFX"]
		
		Resolution=load_dict["Res"]
		CRT_Filer=load_dict["CRT"]
		Fullscreen=load_dict["Fullscreen"]
		
		#create default to ensure we at least have someting
		create_def_input_map()
		var tmp_dicts:Array=load_dict["Input"]
		
		for i:int in range(0,tmp_dicts.size()):
			Player_Input_Dicts[i]=tmp_dicts[i] as Dictionary
		load_player_input_dicts()
		#add gamepad input
		print("loading gamepad input")
		for i:int in 8:
			add_gamepad_input(i)
		
		var custom_face_bytes:Array=load_dict["CstmFcs"] 
		
		var custom_faces:Array[Texture2D]=[]
		for n:PackedByteArray in custom_face_bytes:
			custom_faces.append(FacesAutoload.bytes_to_face(n as PackedByteArray))
		FacesAutoload.custom_faces=custom_faces
		
		file.close()
		
	#SAVE FILE DOESA NOT EXIST:
	else:
		Master=100
		Music=50
		SFX=50
		Resolution=Vector2i(1280,720)
		CRT_Filer=false
		Fullscreen=false
		
		create_def_input_map()
		FacesAutoload.custom_faces=[]
		
		save_data()
	apply_video_settings()
	apply_audio_settings()
