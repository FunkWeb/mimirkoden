extends AnimatableBody2D

var board
var start_pos
var current_cell
@export var active_player:bool
var moves
var cell_index
var keys
var battery
var new_tile # new tile just moved to
var used_tiles # track tiles moved to in current turn
var walk_walls # if card used to walk through walls
var move_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	board = $"../Board"
	move_sound = $"../AudioStreamPlayer"
	# temp values for testing:
	battery = 20
	moves = 3
	keys = 10
	walk_walls = true
	
	# start positions: (-4, 6), (3, 6), (6, -1), (3, -8), (-4, -8), (-8, -1)
	current_cell = Vector2i(-4,6)
	start_pos = board.get_map_pos(current_cell)
	set_position(start_pos)
	used_tiles = []
	
func new_tile_effect(tile):
	if tile.type == "ground":
		battery += 1
		battery = min(battery, 20) # max 20 battery
	elif tile.type == "start":
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

func item_shop():
	# show shop menu
	# 3 randomly picked cards to buy (can't buy same card twice!)
	# one time buy to refresh the cards
	# keys (can buy multiple)
	pass

func draw_card():
	# draws a random card
	# if it's a card you keep the card should be removed from the deck
	# store and display the kept card for the player
	pass

func draw_special_card():
	# 1/3 chance to draw: no effect, lose 3 keys, move to start
	pass

func out_of_battery():
		set_position(start_pos) # move to start position
		moves = 0
		keys = max(0, keys-1) # lose a key

func move_player(clicked_cell):
	set_position(board.map_coords)
	moves -= 1
	current_cell = clicked_cell
	cell_index = board.get_index_from_coor(current_cell)
	new_tile = board.tile_list[cell_index]
	new_tile.occupied = true
	used_tiles.append(current_cell)

func _on_board_clicked():
	if !active_player or moves == 0:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell)
	var clicked_cell = board.clicked_cell
	
	if clicked_cell not in neighbors:
		return
	move_player(clicked_cell)
	move_sound.play()
	new_tile_effect(new_tile)
	if moves == 0:
		# Maybe have an end turn button so the player can use cards after their last move
		end_turn(used_tiles)

func end_turn(used_tile_list):
	if battery == 0:
		out_of_battery()
	print("ending turn, next player:")
	used_tile_list.pop_back() # remove last tile so it stays occupied for next player
	for tile in used_tile_list:
		var index = board.get_index_from_coor(tile)
		board.tile_list[index].occupied = false

	used_tiles.clear()
	# switch player, make sure current tile is added to used_tiles at start of turn
	used_tiles = [current_cell]
	moves = 3
