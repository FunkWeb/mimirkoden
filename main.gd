extends Node

@onready var board = $Board
@onready var Player = $Player

var players = []
var num_selected_players = 6 # Will be set by start menu


func _ready():
#	pass
	$QuitUI.hide()
	$StartUI.update_player_count(num_selected_players)
	
	

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		$QuitUI.show()
		$StartUI.hide()

func _on_start_ui_start_game():
	for player in num_selected_players:
		players.push_back(Player.duplicate())
	
	for player in players:
		player.set_position(Vector2(200,200))
		print(player.position)
	$StartUI.hide()


func _on_start_ui_players(num: int):
	num_selected_players = num
	
