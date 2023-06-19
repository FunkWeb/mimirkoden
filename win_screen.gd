extends Node

func _ready():
	$win_label.text = "{name} vant!".format({"name":GameManager.winning_player})
	GameManager.play_win_music()

func _on_button_return_pressed():
	GameManager.play_background_music()
	GameManager.change_scene_to_menu()

func _on_button_quit_pressed():
	GameManager.quit_game()
