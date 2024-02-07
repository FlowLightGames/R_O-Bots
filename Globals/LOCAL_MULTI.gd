extends Node

@onready var number_player :int=0
@onready var curr_stage :int=1
@onready var players : Array

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		for i in players:
			i.queue_free()
		get_tree().quit() # default behavior

func _ready():
#	get_tree().set_auto_accept_quit(false)
	pass
