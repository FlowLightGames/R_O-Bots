
extends Sprite2D



@onready var ani=get_parent().get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func debug():
#	frame=type
#	material.set_shader_param("Type",color)
	
func _process(delta):
	if(ani.animation=="0"||ani.animation=="1"):
		if(ani.frame%2):
			offset.y=0
		else:
			offset.y=-1
	else:
		offset.y=0

