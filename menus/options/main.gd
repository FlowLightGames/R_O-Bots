extends Control

class_name MainOptionPanel

@export var audio_button:Button
@export var video_button:Button
@export var custom_button:Button
@export var save_button:Button
@export var cancel_button:Button

func enable_buttons(what:bool)->void:
	audio_button.disabled=!what
	video_button.disabled=!what
	custom_button.disabled=!what
	save_button.disabled=!what
	cancel_button.disabled=!what


func _on_save_pressed()->void:
	GameConfig.save_data()
	get_tree().change_scene_to_packed(SceneCollection.main_menu)


func _on_cancel_pressed()->void:
	GameConfig.load_data()
	get_tree().change_scene_to_packed(SceneCollection.main_menu)
