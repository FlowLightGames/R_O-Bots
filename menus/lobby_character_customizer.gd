extends Control

@export var type:int
@export var disabled:bool=false
@export var example_character_0:PlayerCharacter
@export var example_character_1:PlayerCharacter

@export var body_color_txt:Label
@export var body_color_txt_shdw:Label
@export var body_txt:Label
@export var body_txt_shdw:Label
@export var face_color_txt:Label
@export var face_color_txt_shdw:Label
@export var face_custom_txt:Label
@export var face_custom_txt_shdw:Label
@export var face_number_txt:Label
@export var face_number_txt_shdw:Label

var max_number_body_color:int=8
var max_number_body_base:int=5
var max_number_face_color:int=8
var max_number_face_base:int=0

var current_body_base:int=0
var current_body_color:int=0

var current_face_base:int=0
var current_face_color:int=0
var current_face_custom:bool=false

func _ready()->void:
	(material as ShaderMaterial).set_shader_parameter("Type",type)
	
	example_character_0.BodyAnimation.play("idle_front_left")
	example_character_1.BodyAnimation.play("idle_front_right")
	
	example_character_0.set_new_body_color(type)
	example_character_1.set_new_body_color(type)
	example_character_0.set_new_face(FacesAutoload.preset_faces[0])
	example_character_1.set_new_face(FacesAutoload.preset_faces[0])
	example_character_0.set_new_face_color(type)
	example_character_1.set_new_face_color(type)
	
	current_body_color=type
	current_face_color=type
	
	body_color_txt.text=str(current_body_color)
	body_color_txt_shdw.text=str(current_body_color)
	face_color_txt.text=str(current_face_color)
	face_color_txt_shdw.text=str(current_face_color)
	
	max_number_face_base=FacesAutoload.preset_faces.size()


func _on_bodycolor_dec_pressed()->void:
	if(!disabled):
		current_body_color=posmod(current_body_color-1,max_number_body_color)
		example_character_0.set_new_body_color(current_body_color)
		example_character_1.set_new_body_color(current_body_color)
		body_color_txt.text=str(current_body_color)
		body_color_txt_shdw.text=str(current_body_color)


func _on_bodycolor_inc_pressed()->void:
	if(!disabled):
		current_body_color=posmod(current_body_color+1,max_number_body_color)
		example_character_0.set_new_body_color(current_body_color)
		example_character_1.set_new_body_color(current_body_color)
		body_color_txt.text=str(current_body_color)
		body_color_txt_shdw.text=str(current_body_color)

func _on_bodytype_dec_pressed()->void:
	if(!disabled):
		current_body_base=posmod(current_body_base-1,max_number_body_base)
		example_character_0.set_new_body(current_body_base)
		example_character_1.set_new_body(current_body_base)
		body_txt.text=str(current_body_base)
		body_txt_shdw.text=str(current_body_base)

func _on_bodytype_inc_pressed()->void:
	if(!disabled):
		current_body_base=posmod(current_body_base+1,max_number_body_base)
		example_character_0.set_new_body(current_body_base)
		example_character_1.set_new_body(current_body_base)
		body_txt.text=str(current_body_base)
		body_txt_shdw.text=str(current_body_base)


func _on_facecolor_dec_pressed()->void:
	if(!disabled):
		current_face_color=posmod(current_face_color-1,max_number_face_color)
		example_character_0.set_new_face_color(current_face_color)
		example_character_1.set_new_face_color(current_face_color)
		face_color_txt.text=str(current_face_color)
		face_color_txt_shdw.text=str(current_face_color)


func _on_facecolor_inc_pressed()->void:
	if(!disabled):
		current_face_color=posmod(current_face_color+1,max_number_face_color)
		example_character_0.set_new_face_color(current_face_color)
		example_character_1.set_new_face_color(current_face_color)
		face_color_txt.text=str(current_face_color)
		face_color_txt_shdw.text=str(current_face_color)

func _on_facetype_dec_pressed()->void:
	if(!disabled):
		current_face_base=posmod(current_face_base-1,max_number_face_base)
		if current_face_custom:
			example_character_0.set_new_face(FacesAutoload.custom_faces[current_face_base])
			example_character_1.set_new_face(FacesAutoload.custom_faces[current_face_base])
		else:
			example_character_0.set_new_face(FacesAutoload.preset_faces[current_face_base])
			example_character_1.set_new_face(FacesAutoload.preset_faces[current_face_base])
		face_number_txt.text=str(current_face_base)
		face_number_txt_shdw.text=str(current_face_base)
	

func _on_facetype_inc_pressed()->void:
	if(!disabled):
		current_face_base=posmod(current_face_base+1,max_number_face_base)
		if current_face_custom:
			example_character_0.set_new_face(FacesAutoload.custom_faces[current_face_base])
			example_character_1.set_new_face(FacesAutoload.custom_faces[current_face_base])
		else:
			example_character_0.set_new_face(FacesAutoload.preset_faces[current_face_base])
			example_character_1.set_new_face(FacesAutoload.preset_faces[current_face_base])
		face_number_txt.text=str(current_face_base)
		face_number_txt_shdw.text=str(current_face_base)

func _on_facepreset_dec_pressed()->void:
	if(!disabled):
		current_face_base=0
		current_face_custom=!current_face_custom
		if current_face_custom:
			max_number_face_base=FacesAutoload.custom_faces.size()
			face_custom_txt.text="Custom"
			face_custom_txt_shdw.text="Custom"
		else:
			max_number_face_base=FacesAutoload.preset_faces.size()
			face_custom_txt.text="Preset"
			face_custom_txt_shdw.text="Preset"
		face_number_txt.text=str(current_face_base)
		face_number_txt_shdw.text=str(current_face_base)

func _on_facepreset_inc_pressed()->void:
	if(!disabled):
		current_face_base=0
		current_face_custom=!current_face_custom
		if current_face_custom:
			max_number_face_base=FacesAutoload.custom_faces.size()
			face_custom_txt.text="Custom"
			face_custom_txt_shdw.text="Custom"
		else:
			max_number_face_base=FacesAutoload.preset_faces.size()
			face_custom_txt.text="Preset"
			face_custom_txt_shdw.text="Preset"
		face_number_txt.text=str(current_face_base)
		face_number_txt_shdw.text=str(current_face_base)

