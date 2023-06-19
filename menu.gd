extends Node

func _on_button_rules_pressed():
	GameManager.change_scene_to_rules()

func _on_button_credits_pressed():
	GameManager.change_scene_to_credits()

func _on_button_quit_pressed():
	GameManager.quit_game()
