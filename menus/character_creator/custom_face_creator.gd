extends Control

class_name FaceCustomizer

signal cancel

@export var custom_face_selector:CustomFaceSelector
@export var custom_focus_UI:CustomFocusUI
var currently_handled_index:int=0

@export
var example_character_0:PlayerCharacter
@export
var example_character_1:PlayerCharacter

@export
var max_number_body_color:int=8
@export
var max_number_body_base:int=6
@export
var max_number_face_color:int=8

@export
var body_color_txt:Label
@export
var body_txt:Label
@export
var face_color_txt:Label


var current_body_color:int=0
var current_body_base:int=0

var current_face_color:int=0
var current_face_custom:int=0

func _ready()->void:
	example_character_0.set_new_body(0)
	example_character_0.set_new_body_color(0)
	example_character_0.set_new_face_color(0)
	example_character_0.disabled=true
	example_character_0.BodyAnimation.play("run_front_left")

	example_character_1.set_new_body(0)
	example_character_1.set_new_body_color(0)
	example_character_1.set_new_face_color(0)
	example_character_1.disabled=true
	example_character_0.BodyAnimation.play("run_front_left")



func _on_dec_body_base_pressed()->void:
	current_body_base=posmod(current_body_base-1,max_number_body_base)
	example_character_0.set_new_body(current_body_base)
	example_character_1.set_new_body(current_body_base)
	body_txt.text=str(current_body_base)


func _on_inc_body_base_pressed()->void:
	current_body_base=posmod(current_body_base+1,max_number_body_base)
	example_character_0.set_new_body(current_body_base)
	example_character_1.set_new_body(current_body_base)
	body_txt.text=str(current_body_base)


func _on_dec_body_color_pressed()->void:
	current_body_color=posmod(current_body_color-1,max_number_body_color)
	example_character_0.set_new_body_color(current_body_color)
	example_character_1.set_new_body_color(current_body_color)
	body_color_txt.text=str(current_body_color)

func _on_inc_body_color_pressed()->void:
	current_body_color=posmod(current_body_color+1,max_number_body_color)
	example_character_0.set_new_body_color(current_body_color)
	example_character_1.set_new_body_color(current_body_color)
	body_color_txt.text=str(current_body_color)

func _on_dec_face_color_pressed()->void:
	current_face_color=posmod(current_face_color-1,max_number_face_color)
	example_character_0.set_new_face_color(current_face_color)
	example_character_1.set_new_face_color(current_face_color)
	face_color_txt.text=str(current_face_color)


func _on_inc_face_color_pressed()->void:
	current_face_color=posmod(current_face_color+1,max_number_face_color)
	example_character_0.set_new_face_color(current_face_color)
	example_character_1.set_new_face_color(current_face_color)
	face_color_txt.text=str(current_face_color)


func _on_cancel_pressed()->void:
	visible=false
	cancel.emit()


func _on_save_pressed()->void:
	var texture:ImageTexture=custom_focus_UI.build_texture()
	custom_face_selector.finished_custom(currently_handled_index,texture)
	visible=false
	cancel.emit()
