extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	global_position=get_global_mouse_position()
