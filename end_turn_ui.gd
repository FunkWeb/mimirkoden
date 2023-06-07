extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound
@onready var screen_size = get_viewport().get_visible_rect().size

# Uncomment ConfirmationDialog or ConfirmationWindow
#@onready var confirmation_option = $ConfirmationDialog
@onready var confirmation_option = $ConfirmationWindow

# Called when the node enters the scene tree for the first time.
func _ready():
	$ConfirmationWindow.position = Vector2(screen_size[0]/2 - 150,screen_size[1]/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_turn_button_pressed():
	select_sound.play()
	
	if main.get_active_player().moves > 0:
		confirmation_option.show()
		$EndTurnButton.hide()
		$EndTurnLabel.hide()
	else:
		end_turn.emit()


func _on_yes_button_pressed():
	select_sound.play()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()	


func _on_no_button_pressed():
	select_sound.play()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()


func _on_confirmation_window_canceled():
	select_sound.play()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()


func _on_confirmation_window_confirmed():
	select_sound.play()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()
