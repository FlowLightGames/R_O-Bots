extends Control
class_name ChatMessage

@export var panel_node:PanelContainer

@export var message_text:Label
@export var sender_text:Label

func set_message(sender:String,player_number:int,message:String)->void:
	
	message_text.text=message
	sender_text.text=sender
	
	(panel_node.material as ShaderMaterial).set_shader_parameter("Type",player_number)
