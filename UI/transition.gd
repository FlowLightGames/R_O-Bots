extends CanvasLayer

signal finished_transition


func _on_animation_player_animation_finished(_anim_name:String)->void:
	finished_transition.emit()
