extends Control

@export var master_val:Label
@export var master_slider:HSlider
@export var music_val:Label
@export var music_slider:HSlider
@export var SFX_val:Label
@export var SFX_slider:HSlider

signal cancel

func _ready()->void:
	master_slider.value=GameConfig.Master
	master_val.text=str(GameConfig.Master)
	
	music_slider.value=GameConfig.Music
	music_val.text=str(GameConfig.Music)
	
	SFX_slider.value=GameConfig.SFX
	SFX_val.text=str(GameConfig.SFX)

func _on_master_slider_drag_ended(_value_changed:bool)->void:
	master_val.text=str(master_slider.value)

func _on_music_slider_drag_ended(_value_changed:bool)->void:
	music_val.text=str(music_slider.value)

func _on_sfxs_lider_drag_ended(_value_changed:bool)->void:
	SFX_val.text=str(SFX_slider.value)

func _on_sfxs_lider_value_changed(_value:float)->void:
	SFX_val.text=str(SFX_slider.value)

func _on_music_slider_value_changed(_value:float)->void:
	music_val.text=str(music_slider.value)

func _on_master_slider_value_changed(_value:float)->void:
	master_val.text=str(master_slider.value)

func _on_save_pressed()->void:
	GameConfig.Master=master_slider.value
	GameConfig.Music=music_slider.value
	GameConfig.SFX=SFX_slider.value
	GameConfig.apply_audio_settings()
	cancel.emit()


func _on_cancel_pressed()->void:
	cancel.emit()
