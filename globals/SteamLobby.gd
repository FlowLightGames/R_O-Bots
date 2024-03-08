extends Node

const PACKET_READ_LIMIT: int = 32

var is_host:bool=false
var player_number:int=0

var lobby_id: int = 0
var lobby_members: Array[Dictionary] = []
var lobby_members_max: int = 8
var lobby_vote_kick: bool = false

var player_assignment_dict:Dictionary={}

func _ready()->void:
	Steam.join_requested.connect(_on_lobby_join_requested)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_data_update.connect(_on_lobby_data_update)
	Steam.lobby_invite.connect(_on_lobby_invite)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_message.connect(_on_lobby_message)
	Steam.persona_state_change.connect(_on_persona_change)
	
	Steam.p2p_session_request.connect(_on_p2p_session_request)
	Steam.p2p_session_connect_fail.connect(_on_p2p_session_connect_fail)

	# Check for command line arguments
	check_command_line()

func _physics_process(_delta:float)->void:
	if lobby_id > 0:
		read_p2p_packet()

### returns successful assignment -1 if error
func add_player_assignment(player_id:int)->int:
	if player_assignment_dict.size()>8:
		return -1
	else:
		var idx:int=player_assignment_dict.size()
		player_assignment_dict[idx]=player_id
		return idx

func join_lobby(this_lobby_id:int)->void:
	lobby_members.clear()
	is_host=false
	Steam.joinLobby(this_lobby_id)

func leave_lobby()->void:
	if lobby_id!=0:
		Steam.leaveLobby(lobby_id)
		
		is_host=false
		player_assignment_dict.clear()
		lobby_id=0
		
		for member:Dictionary in lobby_members:
			if member["steam_id"]!=GlobalSteam.steam_id:
				Steam.closeP2PSessionWithUser(member["steam_id"])
		
		lobby_members.clear()

func create_lobby()->void:
	#make shure a lobby is not already set
	if lobby_id==0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC,lobby_members_max)

func read_all_p2p_packets(read_count:int=0)->void:
	if read_count>=PACKET_READ_LIMIT:
		return
	if Steam.getAvailableP2PPacketSize(0)>0:
		read_p2p_packet()
		read_all_p2p_packets(read_count+1)

func read_p2p_packet()->void:
	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
	if packet_size > 0:
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
		if this_packet.is_empty() or this_packet == null:
			print("WARNING: read an empty packet with non-zero size!")
		var packet_sender: int = this_packet["steam_id_remote"]
		var packet_code: PackedByteArray = this_packet["data"]
		var readable_data: PackedByteArray = packet_code.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP)
		# Append logic here to deal with packet data
		PackageDeconstructor.handle_data(readable_data,packet_sender)

func send_p2p_packet(this_target: int,send_type:int, packet_data:PackedByteArray) -> void:
	var channel: int = 0
	
	match this_target:
		# If sending a packet to lobby owner
		-1:
			var target_steamID:int=Steam.getLobbyOwner(lobby_id)
			Steam.sendP2PPacket(target_steamID, packet_data, send_type, channel)
		# If sending a packet to everyone
		0:
			# If there is more than one user, send packets
			if lobby_members.size() > 1:
				# Loop through all members that aren't you
				for this_member:Dictionary in lobby_members:
					if this_member['steam_id'] != GlobalSteam.steam_id:
						Steam.sendP2PPacket(this_member['steam_id'], packet_data, send_type, channel)
	 # Else send it to someone specific
		_:
			Steam.sendP2PPacket(this_target, packet_data, send_type, channel)

func get_lobby_members()->void:
	lobby_members.clear()
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)
	for this_member:int in range(0, num_of_members):
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		lobby_members.append({"steam_id":member_steam_id, "steam_name":member_steam_name})

func make_p2p_handshake()->void:
	send_p2p_packet(0,Steam.P2P_SEND_RELIABLE,PackageConstructor.handshake_req(GlobalSteam.steam_id))

func check_command_line()->void:
	var these_arguments:PackedStringArray=OS.get_cmdline_args()
	if these_arguments.size()>0:
		if these_arguments[0]=="+connect_lobby":
			if int(these_arguments[1])>0:
				#TODO Change scene
				print("Command line lobby ID: %s" % these_arguments[1])
				join_lobby(int(these_arguments[1]))

func _on_open_lobby_list_query()->void:
	#add filters here
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.requestLobbyList()

func _on_lobby_match_list(these_lobbies:Array[int])->void:
	for this_lobby:int in these_lobbies:
		#get custom lobby data
		var lobby_value:String=Steam.getLobbyData(this_lobby,"key")
		
		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)
		
		## Create a button for the lobby
		#var lobby_button: Button = Button.new()
		#lobby_button.set_text("Lobby %s: %s [%] - %s Player(s)" % [this_lobby, lobby_name, lobby_mode, lobby_num_members])
		#lobby_button.set_size(Vector2(800, 50))
		#lobby_button.set_name("lobby_%s" % this_lobby)
		#lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))
		
		## Add the new lobby to the list
		#$Lobbies/Scroll/List.add_child(lobby_button)

func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	lobby_id=this_lobby_id
	Steam.setLobbyJoinable(lobby_id, true)
	var set_name_on_lobby:bool=Steam.setLobbyData(lobby_id, "name", GlobalSteam.steam_username)
	print("set name on lobby: "+str(set_name_on_lobby))
	is_host=true
	var set_relay: bool = Steam.allowP2PPacketRelay(true)
	#custom
	player_assignment_dict[0]=GlobalSteam.steam_id

func _on_lobby_joined(this_lobby_id:int,_permissions:int,_locked:bool,response: int) -> void:
	if response==Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id=this_lobby_id
		get_lobby_members()
		make_p2p_handshake()
		is_host=false
		#custom send player number ass request
		print("sending player number request")
		var msg:PackedByteArray=PackageConstructor.player_number_request(GlobalSteam.steam_id)
		send_p2p_packet(-1,Steam.P2P_SEND_RELIABLE,msg)
	else:
		var fail_reason:String
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."
		
		#Reopen the lobby list
		#_on_open_lobby_list_pressed()

func _on_lobby_join_requested(this_lobby_id:int,friend_id:int)->void:
	var owner_name:String=Steam.getFriendPersonaName(friend_id)
	join_lobby(this_lobby_id)

func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	if lobby_id>0:
		get_lobby_members()

func _on_lobby_chat_update(this_lobby_id: int, change_id: int, making_change_id: int, chat_state: int) -> void:
		#TODO HANDLE CASE WHEN HOST LEFT
			#TODO HANDLE CASE WHEN HOST LEFT
				#TODO HANDLE CASE WHEN HOST LEFT
					#TODO HANDLE CASE WHEN HOST LEFT
						#TODO HANDLE CASE WHEN HOST LEFT
	var changer_name: String = Steam.getFriendPersonaName(change_id)
	match chat_state:
		Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
			print("%s has joined the lobby." % changer_name)
		Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
			print("%s has left the lobby." % changer_name)
		Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
			print("%s has been kicked from the lobby." % changer_name)
		Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
			print("%s has been banned from the lobby." % changer_name)
		_:
			print("%s did... something." % changer_name)
	
	get_lobby_members()

#TODO
func _on_lobby_data_update(success :int, lobby_id :int, member_id :int)->void:
	print("LOBBY DATA CHANGED")

func _on_lobby_invite()->void:
	pass

func _on_lobby_message()->void:
	pass

func _on_p2p_session_request(remote_id: int) -> void:
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	# Accept the P2P session; can apply logic to deny this request if needed
	Steam.acceptP2PSessionWithUser(remote_id)
	make_p2p_handshake()

func _on_p2p_session_connect_fail(steam_id: int, session_error: int) -> void:
	match session_error:
		0:
			print("WARNING: Session failure with %s: no error given" % steam_id)
		1:
			print("WARNING: Session failure with %s: target user not running the same game" % steam_id)
		2:
			print("WARNING: Session failure with %s: local user doesn't own app / game" % steam_id)
		3:
			print("WARNING: Session failure with %s: target user isn't connected to Steam" % steam_id)
		4:
			print("WARNING: Session failure with %s: connection timed out" % steam_id)
		5:
			print("WARNING: Session failure with %s: unused" % steam_id)
		_:
			print("WARNING: Session failure with %s: unknown error %s" % [steam_id, session_error])
	

