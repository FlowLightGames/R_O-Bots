extends Node

enum ONLINE_SCENES{LOBBY,STAGE_SELECT}

var main_menu:PackedScene=load("res://menus/main_menu/main_menu.tscn") as PackedScene
var online_lobby:PackedScene=load("res://menus/lobby/online_lobby.tscn") as PackedScene
var offline_lobby:PackedScene=load("res://menus/lobby/offline_lobby.tscn") as PackedScene
var lobby_search:PackedScene=load("res://menus/lobby/online_lobby_list.tscn") as PackedScene
var stage_select:PackedScene=load("res://menus/stage_select/stage_select.tscn") as PackedScene
var options:PackedScene=load("res://menus/options/options.tscn") as PackedScene
