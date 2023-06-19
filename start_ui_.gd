extends Control

var num_players = 2

@onready var main = $".."
@onready var select_sound = $"../SelectSound"

func _ready():
	update_player_count()

func update_player_count():
	$Players.text = "Spillere: {num}".format({"num":num_players})

func player_count_button_pressed(id):
	num_players = id
	update_player_count()
	GameManager.play_select_sound()

func _on_button_2_pressed():
	player_count_button_pressed(2)

func _on_button_3_pressed():
	player_count_button_pressed(3)

func _on_button_4_pressed():
	player_count_button_pressed(4)

func _on_button_5_pressed():
	player_count_button_pressed(5)

func _on_button_6_pressed():
	player_count_button_pressed(6)

func _on_start_pressed():
	GameManager.play_select_sound()
	GameManager.num_selected_players = num_players
	GameManager.change_scene_to_game()
