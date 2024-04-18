extends Node

enum BOMBTYPE{
	DEFAULT,BANANA,E,REMOTE,MINE,DICE,PLASMA,HYDROGEN
}

var Dice:PackedScene=load("res://bombs/instances/dice.tscn")
var Default:PackedScene=load("res://bombs/instances/default.tscn")
var Banana:PackedScene=load("res://bombs/instances/banana.tscn")
var Plasma:PackedScene=load("res://bombs/instances/plasma.tscn")
var Hydrogen:PackedScene=load("res://bombs/instances/hydrogen.tscn")
var E:PackedScene=load("res://bombs/instances/E.tscn")
var Mine:PackedScene=load("res://bombs/instances/mine.tscn")
var Remote:PackedScene=load("res://bombs/instances/remote.tscn")
