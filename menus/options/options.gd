extends Node2D

enum State{
	DEFAULT,AUDIO,VIDEO,CUSTOM
}
@export var audio_panel:Control
@export var video_panel:Control
@export var custom_panel:Control
@export var main_panel:MainOptionPanel

var current_state:State=State.DEFAULT

func _on_audio_pressed()->void:
	if current_state==State.DEFAULT:
		audio_panel.visible=true
		current_state=State.AUDIO
		main_panel.enable_buttons(false)

func _on_video_pressed()->void:
	if current_state==State.DEFAULT:
		video_panel.visible=true
		current_state=State.VIDEO
		main_panel.enable_buttons(false)

func _on_customize_pressed()->void:
	if current_state==State.DEFAULT:
		custom_panel.visible=true
		current_state=State.CUSTOM
		main_panel.enable_buttons(false)


func _on_cancel_pressed()->void:
	match current_state:
		State.AUDIO:
			audio_panel.visible=false
			current_state=State.DEFAULT
			main_panel.enable_buttons(true)
		State.VIDEO:
			video_panel.visible=false
			current_state=State.DEFAULT
			main_panel.enable_buttons(true)
		State.CUSTOM:
			custom_panel.visible=false
			current_state=State.DEFAULT
			main_panel.enable_buttons(true)
		_:
			pass

