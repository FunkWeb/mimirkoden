extends CanvasLayer

func _on_quit_pressed():
	GameManager.play_select_sound()
	GameManager.change_scene_to_menu()

func _on_cancel_pressed():
	hide()
	GameManager.play_select_sound()
