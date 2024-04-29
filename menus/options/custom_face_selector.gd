extends PanelContainer
class_name CustomFaceSelector

signal cancel

var custom_face_option:PackedScene=load("res://menus/options/custom_face_option.tscn") as PackedScene

@export var list_root:VBoxContainer
@export var num_of_slots_label:Label
@export var add_slot_button:Button

@export var face_customizer:FaceCustomizer

var current_num_of_slots:int=0

func _ready()->void:
	var idx:int=0
	for n:Texture2D in FacesAutoload.custom_faces:
		var tmp:CustomFaceOption=custom_face_option.instantiate() as CustomFaceOption
		tmp.set_init(idx,n)
		list_root.add_child(tmp)
		
		tmp.custom_clicked.connect(_on_option_custom_pressed)
		tmp.delete_clicked.connect(_on_option_delete_pressed)
		
		current_num_of_slots+=1
		idx+=1
	
	num_of_slots_label.text=str(current_num_of_slots)+"/"+str(FacesAutoload.max_custom_faces)
	
	if current_num_of_slots>=FacesAutoload.max_custom_faces:
		add_slot_button.disabled=true

func finished_custom(idx:int,texture:Texture2D)->void:
	(list_root.get_child(idx) as CustomFaceOption).set_texture(texture)

func _on_option_custom_pressed(idx:int)->void:
	visible=false
	face_customizer.currently_handled_index=idx
	face_customizer.custom_focus_UI.load_texture((list_root.get_child(idx) as CustomFaceOption).current_texture)
	face_customizer.visible=true

func _on_option_delete_pressed(idx:int)->void:
	#var child_to_free:Node=list_root.get_child(idx)
	#child_to_free.free()
	var all_children:Array[Node]=list_root.get_children()
	var move_up:bool=false
	var iter_idx:int=0
	for n:CustomFaceOption in all_children:
		if iter_idx==idx:
			n.queue_free()
			move_up=true
		elif move_up:
			n.index=n.index-1
		iter_idx+=1
	current_num_of_slots-=1
	num_of_slots_label.text=str(current_num_of_slots)+"/"+str(FacesAutoload.max_custom_faces)

func _on_cancel_pressed()->void:
	visible=false
	cancel.emit()

func _on_save_pressed()->void:
	var tex_array:Array[Texture2D]=[]
	for n:CustomFaceOption in list_root.get_children():
		if n.current_texture:
			tex_array.append(n.current_texture)
	FacesAutoload.custom_faces=tex_array
	
	visible=false
	cancel.emit()


func _on_add_slot_pressed()->void:
	if current_num_of_slots<FacesAutoload.max_custom_faces:
		var tmp:CustomFaceOption=custom_face_option.instantiate() as CustomFaceOption
		tmp.set_init(current_num_of_slots,null)
		list_root.add_child(tmp)
		
		tmp.custom_clicked.connect(_on_option_custom_pressed)
		tmp.delete_clicked.connect(_on_option_delete_pressed)
		
		current_num_of_slots+=1
		
		if current_num_of_slots>=FacesAutoload.max_custom_faces:
			add_slot_button.disabled=true
		
		num_of_slots_label.text=str(current_num_of_slots)+"/"+str(FacesAutoload.max_custom_faces)


func _on_face_custom_cancel()->void:
	visible=true
