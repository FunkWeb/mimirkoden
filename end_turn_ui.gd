extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var board = $"../Board"
@onready var screen_size = get_viewport().get_visible_rect().size
@onready var confirmation_option = $ConfirmationDialog

func _on_end_turn_button_pressed():
	if main.waiting:
		return
	
	var player_tile = main.players[main.current_active_player].current_cell
	var cell_index = board.get_index_from_coor(player_tile)
	var tile = board.tile_list[cell_index]
	if tile.type == "wall":
		return
	GameManager.play_select_sound()
	
	if main.get_active_player().moves > 0:
		confirmation_option.show()
		$EndTurnButton.hide()
		$EndTurnLabel.hide()
	else:
		end_turn.emit()


func _on_yes_button_pressed():
	GameManager.play_select_sound()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()


func _on_no_button_pressed():
	GameManager.play_select_sound()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()


func _on_confirmation_window_canceled():
	GameManager.play_select_sound()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()


func _on_confirmation_window_confirmed():
	GameManager.play_select_sound()
	confirmation_option.hide()
	$EndTurnButton.show()
	$EndTurnLabel.show()
	end_turn.emit()
