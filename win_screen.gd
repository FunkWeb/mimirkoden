extends Node
@onready var button_quit = $ButtonQuit

func _on_button_quit_button_down():
	get_tree().quit()
