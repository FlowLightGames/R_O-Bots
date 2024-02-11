extends Node

const max_custom_faces:int=24
const bytes_per_face:int=216
const tex_width:int=12
const tex_height:int=18

var preset_faces:Array[CompressedTexture2D]=[
	preload("res://player_character/face_presets/face_preset_sprite1.png"),
	preload("res://player_character/face_presets/face_preset_sprite2.png"),
	preload("res://player_character/face_presets/face_preset_sprite3.png"),
	preload("res://player_character/face_presets/face_preset_sprite4.png"),
	preload("res://player_character/face_presets/face_preset_sprite5.png"),
	preload("res://player_character/face_presets/face_preset_sprite6.png"),
	preload("res://player_character/face_presets/face_preset_sprite7.png"),
	preload("res://player_character/face_presets/face_preset_sprite8.png"),
	preload("res://player_character/face_presets/face_preset_sprite9.png"),
	preload("res://player_character/face_presets/face_preset_sprite10.png"),
	preload("res://player_character/face_presets/face_preset_sprite11.png"),
	preload("res://player_character/face_presets/face_preset_sprite12.png"),
	preload("res://player_character/face_presets/face_preset_sprite13.png"),
	preload("res://player_character/face_presets/face_preset_sprite14.png"),
	preload("res://player_character/face_presets/face_preset_sprite15.png"),
	preload("res://player_character/face_presets/face_preset_sprite16.png"),
	preload("res://player_character/face_presets/face_preset_sprite17.png"),
	preload("res://player_character/face_presets/face_preset_sprite18.png"),
	preload("res://player_character/face_presets/face_preset_sprite19.png"),
	preload("res://player_character/face_presets/face_preset_sprite20.png"),
	preload("res://player_character/face_presets/face_preset_sprite21.png"),
	preload("res://player_character/face_presets/face_preset_sprite22.png"),
	preload("res://player_character/face_presets/face_preset_sprite23.png"),
]

var custom_faces:Array[ImageTexture]=[
	
]

func face_to_bytes(input:Texture2D)->PackedByteArray:
	var output:PackedByteArray=PackedByteArray()
	var image:Image=input.get_image()
	var size:int=image.get_height()*image.get_width()
	var color_arr:PackedByteArray=image.get_data()
	for n:int in range(0,size):
		var red:int=color_arr[n*4]
		var alpha:int=color_arr[(n*4)+3]
		if alpha!=0:
			match red:
				255:
					output.append(1)
				_:
					output.append(2)
		else:
			output.append(0)
	return output

func bytes_to_face(input:PackedByteArray,width:int=tex_width,height:int=tex_height)->Texture2D:
	var tmp_data:PackedByteArray=PackedByteArray()
	for n:int in input:
		match n:
			0:
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(0)
			1:
				tmp_data.append(255)
				tmp_data.append(255)
				tmp_data.append(255)
				tmp_data.append(255)
			2:
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(255)
			_:
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(128)
				tmp_data.append(0)

	var image:Image=Image.create_from_data(width,height,false,Image.FORMAT_RGBA8,tmp_data)
	return ImageTexture.create_from_image(image)
