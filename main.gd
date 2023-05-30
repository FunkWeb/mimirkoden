extends Node

@onready var board = $Board
@onready var Player = $Player

var players = []
var num_selected_players = 6 # Will be set by start menu

var player_uis = []
var player_ui_positions = [Vector2(20,20),Vector2(20,580),Vector2(20,280),
	Vector2(1000,20),Vector2(1000,580),Vector2(1000,280)]

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
		player.show()
		print(player.position)
	
	set_player_ui()
	
	Player.hide()
	
	$StartUI.hide()


func _on_start_ui_players(num: int):
	num_selected_players = num
	

func set_player_ui():
	var index = 0
	for player in players:
		var ui = $PlayerUI.duplicate()
		ui.pos = player_ui_positions[index]
		ui.player = player
		ui.show()
		player_uis.push_back(ui)
		index += 1
		
	$PlayerUI.hide()
