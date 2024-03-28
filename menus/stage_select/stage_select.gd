extends Node2D

@export var stage_label:Label
@export var size_label:Label
@export var stage_preview:StagePreview


enum Size {
	S,M,L
}

var max_sizes:int=3
var max_stages:int=0

var current_size:Size=Size.M
var current_stage:int=0

func _ready()->void:
	
	max_stages=stage_preview.stage_previews.size()
	
	current_size=Size.M
	current_stage=0
	apply_new_selection()

func apply_new_selection()->void:
	size_label.text=Size.keys()[current_size]
	stage_label.text=str(current_stage)
	stage_preview.set_tileset_preview(current_stage)
	

func _on_stage_dec_pressed()->void:
	if SteamLobby.is_host:
		current_stage=posmod(current_stage-1,max_stages)
		apply_new_selection()


func _on_stage_inc_pressed()->void:
	if SteamLobby.is_host:
		current_stage=posmod(current_stage+1,max_stages)
		apply_new_selection()


func _on_size_dec_pressed()->void:
	if SteamLobby.is_host:
		current_size=posmod(current_size-1,max_sizes)
		apply_new_selection()


func _on_size_inc_pressed()->void:
	if SteamLobby.is_host:
		current_size=posmod(current_size+1,max_sizes)
		apply_new_selection()


func _on_cancel_pressed()->void:
	#TODO logic
	
	pass # Replace with function body.

func _on_go_pressed()->void:
	if SteamLobby.is_host:
		SteamLobby.random_seed=randi()
		#change this TODO
		var msg:PackedByteArray=PackageConstructor.stage_start_up_master(0,0)
