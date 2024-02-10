extends Node
var SteamAppId:int=480

var is_on_steam_deck: bool 
var is_online: bool  
var is_owned: bool 
var steam_id: int  
var steam_username: String 

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx(true, SteamAppId)
	print("Did Steam initialize?: %s " % initialize_response)
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()
	is_on_steam_deck= Steam.isSteamRunningOnSteamDeck()
	is_online= Steam.loggedOn()
	is_owned= Steam.isSubscribed()
	steam_id= Steam.getSteamID()
	steam_username= Steam.getPersonaName()
	if is_owned == false:
		print("User does not own this game")
		get_tree().quit()

func _ready()->void:
	initialize_steam()

func _physics_process(_delta: float) -> void:
	Steam.run_callbacks()
