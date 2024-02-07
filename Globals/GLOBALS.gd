extends Node

@onready var power_up=preload("res://PowerUps/Power_Up.tscn")

@onready var Current_Players : Array

func set_crt(mode:bool):
	get_tree().get_root().get_node("SubViewport/Filter/ColorRect").visible=mode

func get_crt():
	return get_tree().get_root().get_node("SubViewport/Filter/ColorRect").visible

func change_level(scene_path :String):
	var tmp=get_tree().get_root().get_node("SubViewport/SubViewportContainer/SubViewport")
	var scenes=tmp.get_children()
	for i in scenes:
		i.queue_free()
	tmp.add_child(load(scene_path).instantiate())

func _ready():
	randomize()
