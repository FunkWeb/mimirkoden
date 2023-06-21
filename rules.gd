extends Node

func _on_button_return_pressed():
	GameManager.play_select_sound()
	GameManager.change_scene_to_menu()
