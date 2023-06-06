extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound

func _on_end_turn_button_pressed():
	select_sound.play()
	end_turn.emit()
	pass # Replace with function body.
