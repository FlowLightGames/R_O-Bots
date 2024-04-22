@tool
extends Button
class_name InputRemapButton

var current_player_number:int=0
@export var action_name:String
@export var key_scan:String

@export var action_label:Label
@export var key_scan_label:Label

func _ready()->void:
	action_label.text=action_name
	key_scan_label.text=key_scan

func update_text()->void:
	action_label.text=action_name
	key_scan_label.text=key_scan
