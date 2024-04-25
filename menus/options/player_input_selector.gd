extends PanelContainer
class_name PlayerInputSelector

signal cancel

var player_input_option_block:PackedScene=load("res://menus/options/player_input_option.tscn") as PackedScene

@export var list_root:VBoxContainer
@export var player_input_customizer_interface:PlayerInputSetter

var tmp_changes:Array[Dictionary]=[{},{},{},{},{},{},{},{}]

func _ready()->void:
	for n:int in range(0,8):
		var tmp:PlayerInputOption=player_input_option_block.instantiate() as PlayerInputOption
		tmp.player_num=n
		tmp.pressed.connect(on_player_input_option_pressed)
		list_root.add_child(tmp)
		

func on_player_input_option_pressed(player_num:int)->void:
	visible=false
	player_input_customizer_interface.assign_input_remap_buttons(player_num)
	player_input_customizer_interface.visible=true


func _on_save_pressed()->void:
	#save tmp changes
	var player_idx:int=0
	for dict:Dictionary in tmp_changes:
		for n:String in dict:
			if (dict[n]):
				InputMap.action_erase_events(n)
				InputMap.action_add_event(n,GameConfig.get_input_event(dict[n]))
				GameConfig.Player_Input_Dicts[player_idx][n]=dict[n]
		player_idx+=1
	
	cancel.emit()


func _on_cancel_pressed()->void:
	cancel.emit()
