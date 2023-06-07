extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_turn_button_pressed():
	select_sound.play()
	
	if main.get_active_player().moves > 0:
		# Uncomment ConfirmationDialog or ConfirmationWindow
		#$ConfirmationDialog.show()
		$ConfirmationWindow.show()
		$EndTurnButton.hide()
		$EndTurnLabel.hide()
	else:
		end_turn.emit()


func _on_yes_button_pressed():
	select_sound.play()
	$ConfirmationDialog.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()	


func _on_no_button_pressed():
	select_sound.play()
	$ConfirmationDialog.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()


func _on_confirmation_window_canceled():
	select_sound.play()
	$ConfirmationWindow.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	pass # Replace with function body.


func _on_confirmation_window_confirmed():
	select_sound.play()
	$ConfirmationWindow.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()
	pass # Replace with function body.
