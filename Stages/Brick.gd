extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fading =false
@onready var board =get_parent().get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	if(!fading):
		
		$Sprite2D.visible=false
		$AnimatedSprite2D.visible=true
		$AnimatedSprite2D.playing=true
		fading=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	if posmod(randi(),2):
		var tmp=GLOBALS.power_up.instantiate()
		tmp.type=board.get_random_item()
		tmp.position=position
		board.add_child(tmp)
	queue_free()
