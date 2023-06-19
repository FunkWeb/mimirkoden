extends CanvasLayer

func _on_quit_pressed():
	GameManager.play_select_sound()
	GameManager.quit_game()

func _on_cancel_pressed():
	hide()
	GameManager.play_select_sound()
	if not main.game_started:
		main.StartUI.show()

