extends Control

var num_players = 2

func _ready():
	update_player_count()

func unpress_other_buttons(button_num):
	for i in range(2,7):
		if i == button_num:
			continue
		var button_node = get_node( "Buttons/Button" + str(i))
		button_node.button_pressed = false

func update_player_count():
	$Players.text = "Spillere: {num}".format({"num":num_players})

func player_count_button_pressed(id):
	num_players = id
	update_player_count()
	GameManager.play_select_sound()

func _on_button_2_pressed():
	player_count_button_pressed(2)
	$Buttons/Button2.button_pressed = true
	unpress_other_buttons(2)

func _on_button_3_pressed():
	player_count_button_pressed(3)
	$Buttons/Button3.button_pressed = true
	unpress_other_buttons(3)

func _on_button_4_pressed():
	player_count_button_pressed(4)
	$Buttons/Button4.button_pressed = true
	unpress_other_buttons(4)

func _on_button_5_pressed():
	player_count_button_pressed(5)
	$Buttons/Button5.button_pressed = true
	unpress_other_buttons(5)

func _on_button_6_pressed():
	player_count_button_pressed(6)
	$Buttons/Button6.button_pressed = true
	unpress_other_buttons(6)

func _on_start_pressed():
	GameManager.play_select_sound()
	GameManager.num_selected_players = num_players
	GameManager.change_scene_to_game()
