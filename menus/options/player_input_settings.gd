extends PanelContainer

@export var buttons:Array[InputRemapButton]=[]
@export var curr_player_label:Label

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
	temp_input_event_dict[(str(player_num)+"_Up")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Up")).front())
	
	curr_action_dict["DOWN"]=(str(player_num)+"_Down")
	temp_input_event_dict[(str(player_num)+"_Down")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Down")).front())
	
	curr_action_dict["LEFT"]=(str(player_num)+"_Left")
	temp_input_event_dict[(str(player_num)+"_Left")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Left")).front())
	
	curr_action_dict["RIGHT"]=(str(player_num)+"_Right")
	temp_input_event_dict[(str(player_num)+"_Right")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Right")).front())
	
	curr_action_dict["ACTION_0"]=(str(player_num)+"_Action_0")
	temp_input_event_dict[(str(player_num)+"_Action_0")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Action_0")).front())
	
	curr_action_dict["ACTION_1"]=(str(player_num)+"_Action_1")
	temp_input_event_dict[(str(player_num)+"_Action_1")]=GameConfig.get_input_code(InputMap.action_get_events((str(player_num)+"_Action_1")).front())

func assign_input_remap_buttons(player_num:int)->void:
	curr_player_label.text="Player_"+str(player_num)
	get_curr_player_action_dict(player_num)
	var idx:int=0
	for action:String in curr_action_dict:
		var events:Array[InputEvent]=InputMap.action_get_events(curr_action_dict[action])
		if !(events.is_empty()):
			buttons[idx].action_name=action
			buttons[idx].key_scan=events[0].as_text().trim_suffix(" (Physical)").to_upper()
		else:
			buttons[idx].action_name=action
			buttons[idx].key_scan="Null"
		
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
	for n:String in temp_input_event_dict:
		if (temp_input_event_dict[n]):
			InputMap.action_erase_events(n)
			InputMap.action_add_event(n,GameConfig.get_input_event(temp_input_event_dict[n]))
			GameConfig.Player_Input_Dicts[curr_handled_player_num][n]=temp_input_event_dict[n]


func _on_cancel_pressed()->void:
	cancel.emit()
	reset()
