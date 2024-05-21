extends CanvasLayer
class_name DrawOverlay

@export var can_move_on:bool=false

func _process(delta:float)->void:
	if can_move_on:
		if Input.is_action_just_pressed("ui_accept")||Input.is_action_just_pressed("ui_cancel"):
			MultiplayerStatus.Current_Loaded_Map=null
			get_tree().change_scene_to_packed(SceneCollection.stage_select)
