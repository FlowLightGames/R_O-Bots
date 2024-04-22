extends PanelContainer

@export var buttons:Array[InputRemapButton]=[]
@export var curr_player_label:Label

var curr_handled_player_num:int=0
var curr_action_dict:Dictionary={}

func _ready()->void:
	assign_input_remap_buttons(0)

func get_curr_player_action_dict(player_num:int)->void:
	curr_action_dict={}
	curr_action_dict["UP"]=(str(player_num)+"_Up")
	curr_action_dict["DOWN"]=(str(player_num)+"_Down")
	curr_action_dict["LEFT"]=(str(player_num)+"_Left")
	curr_action_dict["RIGHT"]=(str(player_num)+"_Right")
	curr_action_dict["ACTION_0"]=(str(player_num)+"_Action_0")
	curr_action_dict["ACTION_1"]=(str(player_num)+"_Action_1")

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
			print(curr_action_dict.find_key(action))
			buttons[idx].action_name=action
			buttons[idx].key_scan="Null"
		
		buttons[idx].update_text()
		idx+=1
