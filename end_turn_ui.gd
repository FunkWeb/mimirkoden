extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound
@onready var board = $"../Board"
@onready var screen_size = get_viewport().get_visible_rect().size

@onready var confirmation_option = $ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$ConfirmationWindow.position = Vector2(screen_size[0]/2 - 150,screen_size[1]/2)


func _on_end_turn_button_pressed():
	if main.waiting:
		print("Can't end turn while waiting on player input")
		return
	
	var player_tile = main.players[main.current_active_player].current_cell
	var cell_index = board.get_index_from_coor(player_tile)
	var tile = board.tile_list[cell_index]
	if tile.type == "wall":
		print("can't end turn in a wall")
		return
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
