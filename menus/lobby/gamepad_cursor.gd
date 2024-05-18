extends Sprite2D
class_name GamepadCharacterCustomCursor
var disabled:bool=false

@export var list_of_options:Array[GamepadUIBinding]
var current_index:int=0
var assigned_player:int=0

func update_pos()->void:
	global_position=list_of_options[current_index].position_marker.global_position
func disable()->void:
	visible=false
	disabled=true
	update_pos()
func enable()->void:
	visible=true
	disabled=false
	update_pos()
#func _input(event:InputEvent)->void:
	#if !disabled:
		#if event.is_action_pressed(str(assigned_player)+"_Up"):
			#print("OK KILL HIM WITH HAMMERS UP")
			#current_index=posmod(current_index-1,list_of_options.size())
		#if event.is_action_pressed(str(assigned_player)+"_Down"):
			#print("OK KILL HIM WITH HAMMERS DOWN")
			#current_index=posmod(current_index+1,list_of_options.size())
		#if event.is_action_pressed(str(assigned_player)+"_Left"):
			#print("OK KILL HIM WITH HAMMERS LEFT")
			#list_of_options[current_index].L_button.pressed.emit()
		#if event.is_action_pressed(str(assigned_player)+"_Right"):
			#print("OK KILL HIM WITH HAMMERS RIGHT")
			#list_of_options[current_index].R_button.pressed.emit()
		#
		#update_pos()

func _physics_process(_delta:float)->void:
	if !disabled:
		if Input.is_action_just_pressed(str(assigned_player)+"_Up"):
			#print("OK KILL HIM WITH HAMMERS UP")
			current_index=posmod(current_index-1,list_of_options.size())
		if Input.is_action_just_pressed(str(assigned_player)+"_Down"):
			#print("OK KILL HIM WITH HAMMERS DOWN")
			current_index=posmod(current_index+1,list_of_options.size())
		if Input.is_action_just_pressed(str(assigned_player)+"_Left"):
			#print("OK KILL HIM WITH HAMMERS LEFT")
			if(list_of_options[current_index].L_button):
				list_of_options[current_index].L_button.pressed.emit()
		if Input.is_action_just_pressed(str(assigned_player)+"_Right"):
			#print("OK KILL HIM WITH HAMMERS RIGHT")
			if(list_of_options[current_index].R_button):
				list_of_options[current_index].R_button.pressed.emit()
		
		update_pos()
