extends AnimatableBody2D

# Player control variables
var board
var current_cell

var start_pos
=======
@export var active_player:bool
var moves
var cell_index
var keys # max 10
var battery # max 20
var new_tile # new tile just moved to
var used_tiles # track tiles moved to in current turn
var walk_walls # if card used to walk through walls
var move_sound
var moved_to_start
signal update_ui # emit whenever the ui needs to update values (moves, charges, etc...)



# Called when the node enters the scene tree for the first time.
func _ready():
	print("PLAYER READY")
	board = $"../Board"
	
	# Connect click signal from board to player
	board.clicked.connect(_on_board_clicked)

func init():
	current_cell = start_pos
	set_position(board.get_map_pos(current_cell))


func out_of_battery():
	move_to_start()
	battery = 0 # in case of negative value
	keys = max(0, keys-1) # lose a key

func move_player(clicked_cell):
	moves -= 1
	set_position(board.map_coords)
	current_cell = clicked_cell
	cell_index = board.get_index_from_coor(current_cell)
	new_tile = board.tile_list[cell_index]
	new_tile.occupied = true
	used_tiles.append(current_cell)
	move_sound.play()
	new_tile_effect(new_tile)
	print("felt brukt denne runden: ", used_tiles)
	update_ui.emit() #signal playerUI to update values


func _on_board_clicked():
	if !active_player:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell)
	var clicked_cell = board.clicked_cell
	
	if clicked_cell not in neighbors:
		return

	move_player(clicked_cell)
	# print("batteri: ",battery, " keys: ", keys, " moves: ", moves)
	if moves == 0: # temp end turn. replace with button
		end_turn()

func get_availible_tiles(current_pos, moves_left, list=[]):
	# finds all tiles a player can move to with their remaining moves
	# can be used for simple tile highlighting
	if moves_left == 0:
		return list
	var neighbours = board.get_valid_neighbors(current_pos)
	for cell in neighbours:
		if list.has(cell):
			continue
		list.append(cell)
		list = get_availible_tiles(cell, moves_left-1, list)
	return list

func unset_occupied(tiles):
	for tile in tiles:
		var index = board.get_index_from_coor(tile)
		if index == null:
			print("unset_occupied didn't find index for ", tile)
			continue
		board.tile_list[index].occupied = false

func end_turn():
	print("Slutt på runden, ny spiller sin tur")
	var last_tile = used_tiles.pop_back() # last tile stays occupied
	if battery < 1:
		out_of_battery()
	if moved_to_start:
		unset_occupied(used_tiles+[last_tile])
		used_tiles = []
	else:
		unset_occupied(used_tiles)
		used_tiles = [current_cell]
	update_ui.emit()
	# switch player here
	moves = 3
	update_ui.emit()
	moved_to_start = false
	# print(get_availible_tiles(current_cell, moves))

	
	var cell_pos = board.map_coords
	set_position(cell_pos)
	current_cell = clicked_cell
