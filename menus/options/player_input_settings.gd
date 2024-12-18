extends PanelContainer
class_name PlayerInputSetter

@export var buttons:Array[InputRemapButton]=[]
@export var curr_player_label:Label
@export var player_input_selector:PlayerInputSelector

signal cancel

var curr_handled_player_num:int=1
var curr_action_dict:Dictionary={}

var is_remapping:bool=false
var assign_button:InputRemapButton=null
var assign_action:String=""

var temp_input_event_dict:Dictionary={}

func _ready()->void:
	assign_input_remap_buttons(1)
	for button:InputRemapButton in buttons:
		button.pressed.connect(_on_remap_pressed.bind(button))

func _input(event:InputEvent)->void:
	if is_remapping:
		if (event is InputEventKey||event is InputEventMouseButton):
			#assign temp_dict to overwrite game config
			temp_input_event_dict[assign_action]=GameConfig.get_input_code(event)
			assign_button.key_scan=event.as_text().trim_suffix(" (Physical)").to_upper()
			assign_button.update_text()
			#_update_action_list
			is_remapping=false
			assign_action=""
			assign_button=null
			accept_event()

func reset()->void:
	curr_action_dict={}
	temp_input_event_dict={}
	curr_handled_player_num=0
	curr_action_dict={}
	is_remapping=false
	assign_button=null
	assign_action=""

func get_curr_player_action_dict(player_num:int)->void:
	curr_action_dict={}
	temp_input_event_dict={}
	
	curr_action_dict["UP"]=(str(player_num)+"_Up")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Up")):
		print("HAS IN TMP CHANGES")
		temp_input_event_dict[(str(player_num)+"_Up")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Up")]
		print("IT IS")
		print(temp_input_event_dict[(str(player_num)+"_Up")])
	else:
		print("NOT HAS IN TMP CHANGES")
		temp_input_event_dict[(str(player_num)+"_Up")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Up")).front() as InputEvent)
	
	curr_action_dict["DOWN"]=(str(player_num)+"_Down")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Down")):
		temp_input_event_dict[(str(player_num)+"_Down")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Down")]
	else:
		temp_input_event_dict[(str(player_num)+"_Down")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Down")).front() as InputEvent)
	
	curr_action_dict["LEFT"]=(str(player_num)+"_Left")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Left")):
		temp_input_event_dict[(str(player_num)+"_Left")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Left")]
	else:
		temp_input_event_dict[(str(player_num)+"_Left")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Left")).front() as InputEvent)
	
	curr_action_dict["RIGHT"]=(str(player_num)+"_Right")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Right")):
		temp_input_event_dict[(str(player_num)+"_Right")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Right")]
	else:
		temp_input_event_dict[(str(player_num)+"_Right")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Right")).front() as InputEvent)
	
	curr_action_dict["ACTION_0"]=(str(player_num)+"_Action_0")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Action_0")):
		temp_input_event_dict[(str(player_num)+"_Action_0")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Action_0")]
	else:
		temp_input_event_dict[(str(player_num)+"_Action_0")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Action_0")).front() as InputEvent)
	
	curr_action_dict["ACTION_1"]=(str(player_num)+"_Action_1")
	if player_input_selector.tmp_changes[player_num].has((str(player_num)+"_Action_1")):
		temp_input_event_dict[(str(player_num)+"_Action_1")]=player_input_selector.tmp_changes[player_num][(str(player_num)+"_Action_1")]
	else:
		temp_input_event_dict[(str(player_num)+"_Action_1")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Action_1")).front() as InputEvent)

func assign_input_remap_buttons(player_num:int)->void:
	curr_handled_player_num=player_num
	curr_player_label.text="Player"+str(player_num)
	get_curr_player_action_dict(player_num)
	var idx:int=0
	for action:String in curr_action_dict:
		var event:String=temp_input_event_dict[curr_action_dict[action]]
		if (event):
			buttons[idx].action_name=action
			buttons[idx].key_scan=GameConfig.get_input_event(event).as_text().trim_suffix(" (Physical)").to_upper()
		else:
			buttons[idx].action_name=action
			buttons[idx].key_scan="Null"
		#var events:Array[InputEvent]=InputMap.action_get_events(curr_action_dict[action])
		#if !(events.is_empty()):
			#buttons[idx].action_name=action
			#buttons[idx].key_scan=events[0].as_text().trim_suffix(" (Physical)").to_upper()
		#else:
			#buttons[idx].action_name=action
			#buttons[idx].key_scan="Null"
		
		buttons[idx].update_text()
		idx+=1

func _on_remap_pressed(button:InputRemapButton)->void:
	if !is_remapping:
		is_remapping=true
		assign_button=button
		assign_action=curr_action_dict[button.action_name]
		button.key_scan="PressKey"
		button.update_text()



func _on_default_pressed()->void:
	GameConfig.create_def_input_map_player(curr_handled_player_num)

func _on_save_pressed()->void:
	visible=false
	player_input_selector.tmp_changes[curr_handled_player_num]=temp_input_event_dict
	cancel.emit()
	reset()

func _on_cancel_pressed()->void:
	visible=false
	cancel.emit()
	reset()
