extends AnimatableBody2D
# ny kmmentar
var board
var start_pos
var current_cell
@export var active_player:bool
var moves
var cell_index
var keys # max 10
var battery # max 20
var new_tile # new tile just moved to
var used_tiles # track tiles moved to in current turn
var walk_walls # if card used to walk through walls
var move_sound
signal update_ui # emit whenever the ui needs to update values (moves, charges, etc...)


# Called when the node enters the scene tree for the first time.
func _ready():
	board = $"../Board"
	move_sound = $"../AudioStreamPlayer"
	# temp values for testing:
	battery = 0
	moves = 3
	keys = 0
	walk_walls = false
	
	# start positions: (-4, 6), (3, 6), (6, -1), (3, -8), (-4, -8), (-8, -1)
	current_cell = Vector2i(-4,6)
	start_pos = board.get_map_pos(current_cell)
	set_position(start_pos)
	used_tiles = []
	print(get_availible_tiles(current_cell, moves))

func new_tile_effect(tile):
	if tile.type == "ground":
		battery += 1
		battery = min(battery, 20) # max 20 battery
	elif tile.type == "double":
		battery += 2
		battery = min(battery, 20)
	elif tile.type == "negative":
		battery -= 1
		if battery < 0: # less than 0
			out_of_battery()
	elif tile.type == "lock":
		moves = 0
		keys -= 5
	elif tile.type == "special_card":
		moves = 0
		draw_special_card()
	elif tile.type == "shop":
		moves = 0
		item_shop()
	elif tile.type == "card":
		moves = 0
		draw_card()
	elif tile.type == "win":
		moves = 0
		keys -= 5
		print("Du fant Mimirkoden!")

func item_shop():
	# show shop menu
	# 3 randomly picked cards to buy (can't buy same card twice!)
	# one time buy to refresh the cards
	# keys (can buy multiple)
	while battery > 3 and keys < 10: # temp buy all keys
		battery -= 3
		keys += 1

func draw_card():
	# draws a random card
	# if it's a card you keep the card should be removed from the deck
	# store and display the kept card for the player
	pass

func draw_special_card():
	# TODO display card for player
	var random = randi_range(0,2)
	if random == 0:
		print("ingenting skjer")
		return
	elif random == 1:
		print("3 nøkkler mister funksjonalitet")
		keys = max(0, keys-3)
		return
	else:
		print("Du blir kastet ut")
		moves = 0
		move_to_tile(start_pos)

func move_to_tile(cell):
	unset_occupied([current_cell])
	current_cell = board.get_local_pos(cell)
	set_position(cell)

func out_of_battery():
	move_to_tile(start_pos)
	moves = 0
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
	if !active_player or moves == 0:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell)
	var clicked_cell = board.clicked_cell
	
	# debug info:
	var cell_info = board.tile_list[board.get_index_from_coor(clicked_cell)]
	print("trykk på felt med koordinater: ", clicked_cell)
	print("feltet er et ", cell_info.type, " felt")
	print("feltet er i disse sonene: ", cell_info.zone)
	print("feltet er opptatt") if cell_info.occupied == true else print("feltet er ikke optatt")
	
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
			print("Error, unset_occupied didn't find index for ", tile)
			continue
		board.tile_list[index].occupied = false

func end_turn():
	print("Slutt på runden, ny spiller sin tur")
	var last_tile = used_tiles.pop_back() # last tile stays occupied
	if battery < 1:
		out_of_battery()
	unset_occupied(used_tiles)
	used_tiles = [current_cell]
	update_ui.emit()
	# switch player here
	moves = 3
	update_ui.emit()
	# print(get_availible_tiles(current_cell, moves))
	
