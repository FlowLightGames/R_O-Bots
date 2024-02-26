extends Node

enum BOMBTYPE{
	DEFAULT,BANANA,E,REMOTE,MINE,DICE,PLASMA
}

var Dice:PackedScene=load("res://bombs/instances/dice.tscn")
var Default:PackedScene=load("res://bombs/instances/default.tscn")
var Banana:PackedScene=load("res://bombs/instances/banana.tscn")
var Plasma:PackedScene=load("res://bombs/instances/plasma.tscn")
