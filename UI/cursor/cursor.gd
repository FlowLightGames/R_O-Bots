extends Sprite2D

@export var click_audio:AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED_HIDDEN

func _input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			click_audio.play(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	global_position=get_global_mouse_position()
