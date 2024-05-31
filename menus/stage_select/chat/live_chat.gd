extends ScrollContainer
class_name LiveChat

var message_scene:PackedScene=load("res://menus/stage_select/chat/chat_message.tscn") as PackedScene

@export var root:Control

func _ready()->void:
	PackageDeconstructor.chat_message.connect(_on_message_received)

func spawn_message(steam_id:int,player_number:int,msg:String)->void:
	var tmp:ChatMessage=message_scene.instantiate() as ChatMessage
	tmp.set_message(Steam.getFriendPersonaName(steam_id),player_number,msg)
	root.add_child(tmp)
	root.move_child(tmp,0)

func _on_message_received(sender_steamID:int,msg:String)->void:
	var player_number:int=PlayerConfigs.get_player_index_by_steam_id(sender_steamID)
	if player_number in range(0,PlayerConfigs.Player_Configs.size()):
		if PlayerConfigs.Player_Configs[player_number].steam_id==sender_steamID:
			spawn_message(sender_steamID,player_number,msg)
	
	#set_deferred("scroll_horizontal",1080)
	#set_deferred("scroll_vertical",1080)
