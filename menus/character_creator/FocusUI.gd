extends Sprite2D
class_name CustomFocusUI

@export
var draw_ref:Sprite2D
@export
var canvas:Sprite2D
@export
var pos_ref:TileMap
@export
var size:Vector2i=Vector2i(12,9)
@export
var button_white:TextureButton
@export
var button_gray:TextureButton
@export
var button_mirror:CheckBox
@export
var Example_char_0:PlayerCharacter

@export
var Example_char_1:PlayerCharacter

var image:Image=Image.create(12,9,false,Image.FORMAT_RGBA8)
var current_color:Color=Color8(255,255,255,255)

func _ready()->void:
	Example_char_0.BodyAnimation.play("run_front_left")
	Example_char_1.BodyAnimation.play("run_front_right")

func load_texture(tex:Texture2D)->void:
	if tex:
		var tmp_image:Image=tex.get_image()
		tmp_image=tmp_image.get_region(Rect2i(Vector2i(0,0),Vector2i(12,9)))
		image=tmp_image
		canvas.texture=ImageTexture.create_from_image(image)
		set_example_face(build_texture())
	else:
		var tmp_image:Image=Image.create(12,9,false,Image.FORMAT_RGBA8)
		image=tmp_image
		canvas.texture=ImageTexture.create_from_image(image)
		set_example_face(build_texture())


func set_example_face(input:ImageTexture)->void:
	Example_char_0.set_new_face(input)
	Example_char_1.set_new_face(input)

func build_texture()->ImageTexture:
	var output:Image=Image.create(image.get_width(),image.get_height()*2,false,Image.FORMAT_RGBA8)
	var top:PackedByteArray=image.get_data()
	var tmp_mirror:Image=Image.new()
	tmp_mirror.copy_from(image)
	if (button_mirror.button_pressed):
		tmp_mirror.flip_x()
	var bottom:PackedByteArray=tmp_mirror.get_data()
	var combined:PackedByteArray=top
	combined.append_array(bottom)
	output.set_data(image.get_width(),image.get_height()*2,false,Image.FORMAT_RGBA8,combined)
	return ImageTexture.create_from_image(output)

func _input(event:InputEvent)->void:
	if event is InputEventMouseMotion:
		var mp:Vector2=get_global_mouse_position()-(get_parent() as Node2D).global_position
		var check:Vector2i=pos_ref.local_to_map(mp)
		if check.x in range(0,size.x)&&check.y in range(0,size.y):
			visible=true
			global_position=pos_ref.map_to_local(check)-Vector2(pos_ref.tile_set.tile_size/2)+(get_parent() as Node2D).global_position
			if Input.is_action_pressed("ui_left_mouse"):
				image.set_pixelv(check,current_color)
				canvas.texture=ImageTexture.create_from_image(image)
				set_example_face(build_texture())
			if Input.is_action_pressed("ui_right_mouse"):
				image.set_pixelv(check,Color8(0,0,0,0))
				canvas.texture=ImageTexture.create_from_image(image)
				set_example_face(build_texture())
		else:
			visible=false
	else:
		if event.is_action_pressed("ui_left_mouse",true):
			var mp:Vector2=get_global_mouse_position()-(get_parent() as Node2D).global_position
			var check:Vector2i=pos_ref.local_to_map(mp)
			if check.x in range(0,size.x)&&check.y in range(0,size.y):
				image.set_pixelv(check,current_color)
				canvas.texture=ImageTexture.create_from_image(image)
				set_example_face(build_texture())
		if event.is_action_pressed("ui_right_mouse",true):
			var mp:Vector2=get_global_mouse_position()-(get_parent() as Node2D).global_position
			var check:Vector2i=pos_ref.local_to_map(mp)
			if check.x in range(0,size.x)&&check.y in range(0,size.y):
				image.set_pixelv(check,Color8(0,0,0,0))
				canvas.texture=ImageTexture.create_from_image(image)
				set_example_face(build_texture())

func _on_texture_button_white_pressed()->void:
	button_gray.button_pressed=false
	current_color=(button_white.get_node("ColorRect") as ColorRect).color

func _on_texture_button_gray_pressed()->void:
	button_white.button_pressed=false
	current_color=(button_gray.get_node("ColorRect") as ColorRect).color

func _on_check_box_pressed()->void:
	set_example_face(build_texture())

func _on_clear_pressed()->void:
	image.fill(Color(0, 0, 0, 0))
	canvas.texture=ImageTexture.create_from_image(image)
	set_example_face(build_texture())
