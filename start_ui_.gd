extends Control

signal players
signal start_game

@onready var main = $".."
@onready var select_sound = $"../SelectSound"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_player_count()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_player_count():
	$Players.text = "Spillere: {num}".format({"num":main.num_selected_players})
	

func player_count_button_pressed(id):
	players.emit(id)
	update_player_count()
	select_sound.play()
	pass
	
func _on_button_2_pressed():
	player_count_button_pressed(2)
	pass # Replace with function body.


func _on_button_3_pressed():
	player_count_button_pressed(3)
	pass # Replace with function body.


func _on_button_4_pressed():
	player_count_button_pressed(4)
	pass # Replace with function body.


func _on_button_5_pressed():
	player_count_button_pressed(5)
	pass # Replace with function body.


func _on_button_6_pressed():
	player_count_button_pressed(6)
	pass # Replace with function body.


func _on_start_pressed():
	select_sound.play()
	start_game.emit()
	pass # Replace with function body.
