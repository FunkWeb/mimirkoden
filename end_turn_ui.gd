extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound
@onready var board = $"../Board"

func _on_end_turn_button_pressed():
	var player_tile = main.players[main.current_active_player].current_cell
	var cell_index = board.get_index_from_coor(player_tile)
	var tile = board.tile_list[cell_index]
	if tile.type == "wall":
		print("can't end turn in a wall")
		return
	select_sound.play()
	end_turn.emit()
	pass # Replace with function body.
