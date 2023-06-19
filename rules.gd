extends Node

func _on_button_return_pressed():
	GameManager.play_background_music()
	GameManager.change_scene_to_menu()
