
extends Node

@export
var Max_Players:int=8

func _ready()->void:
	for n:int in range(0,Max_Players):
		InputMap.add_action(str(n)+"_Up")
		var ev:InputEventKey = InputEventKey.new()
		ev.physical_keycode = KEY_W
		InputMap.action_add_event(str(n)+"_Up", ev)
		
		InputMap.add_action(str(n)+"_Left")
		ev = InputEventKey.new()
		ev.physical_keycode = KEY_A
		InputMap.action_add_event(str(n)+"_Left", ev)
		
		InputMap.add_action(str(n)+"_Down")
		ev = InputEventKey.new()
		ev.physical_keycode = KEY_S
		InputMap.action_add_event(str(n)+"_Down", ev)
		
		InputMap.add_action(str(n)+"_Right")
		ev = InputEventKey.new()
		ev.physical_keycode = KEY_D
		InputMap.action_add_event(str(n)+"_Right", ev)
		
		InputMap.add_action(str(n)+"_Action_0")
		ev= InputEventKey.new()
		ev.physical_keycode = KEY_SPACE
		InputMap.action_add_event(str(n)+"_Action_0", ev)
		
		InputMap.add_action(str(n)+"_Action_1")
		ev= InputEventKey.new()
		ev.physical_keycode = KEY_B
		InputMap.action_add_event(str(n)+"_Action_1", ev)

