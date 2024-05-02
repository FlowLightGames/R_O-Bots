extends Area2D

var lightning_scene:PackedScene=load("res://player_character/zeus/zeus_lightning.tscn") as PackedScene
var on_cd:bool=false
@export
var cd_timer:Timer
@export
var strike_timer:Timer

func _on_body_entered(body:Node2D)->void:
	if !on_cd:
		if body is PlayerCharacter:
			strike_timer.start(0.2)
			on_cd=true


func _on_strike_timer_timeout()->void:
	var tmp_light:ZeusLightning=lightning_scene.instantiate() as ZeusLightning
	tmp_light.set_color(1.0)
	add_child(tmp_light)
	cd_timer.start(2.0)


func _on_cd_timer_timeout()->void:
	on_cd=false
