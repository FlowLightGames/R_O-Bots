extends Control

class_name MainOptionPanel

@export var audio_button:Button
@export var video_button:Button
@export var custom_button:Button

func enable_buttons(what:bool)->void:
	audio_button.disabled=!what
	video_button.disabled=!what
	custom_button.disabled=!what
