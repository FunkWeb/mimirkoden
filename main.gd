extends Node

@onready var board = $Board
@onready var Player = $Player

var players = []
var num_selected_players = 6 # Will be set by start menu


func _ready():
#	pass
	for player in num_selected_players:
		players.push_back(Player.duplicate())
	
	for player in players:
		player.set_position(Vector2(200,200))
		print(player.position)
