extends AnimatableBody2D

var player_name
var start_pos
var current_cell
@export var active_player:bool
const max_moves = 3
var moves
var next_turn_moves_modifier = 0
var cell_index
var keys # max 10
var battery # max 20
var new_tile # new tile just moved to
var used_tiles # track tiles moved to in current turn
var walk_walls # if card used to walk through walls
signal update_ui # emit whenever the ui needs to update values (moves, charges, etc...)
@onready var main = $".."
@onready var board = $"../Board"
@onready var move_sound = $"../MoveSound"
@onready var playspace = $"../Playspace"

var hand

# Called when the node enters the scene tree for the first time.
func _ready():
	battery = 0
	moves = max_moves
	keys = 0
	walk_walls = false
	used_tiles = []
	# Connect click signal from board to player
	board.clicked.connect(_on_board_clicked)

func init():
	current_cell = start_pos
	set_position(board.get_map_pos(current_cell))

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
	var card_index = randi_range(0,len(main.chance_cards)-1)
	var card = main.chance_cards.pop_at(card_index)
	print(card.title,card.description,card.activation,card.polarity)
	playspace.draw_card(card)
	
	if card.activation == "Umiddelbar Aktivering":
		main.discard_pile.append(card)
		main.immediate_card_effect(card)
	else:
		draw_card_to_hand(card)

func draw_card_to_hand(card):
	print("Trakk", card, "til hånda")
	print(hand.CardList)
	hand.CardList.push_back(card)
	print(hand.CardList)

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
	current_cell = cell
	set_position(board.get_map_pos(cell))

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
	update_ui.emit() #signal playerUI to update values

func _on_board_clicked():
	if !active_player or moves == 0:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell)
	var clicked_cell = board.clicked_cell
	
	# debug info:
	#var cell_info = board.tile_list[board.get_index_from_coor(clicked_cell)]
	#print("trykk på felt med koordinater: ", clicked_cell)
	#print("feltet er et ", cell_info.type, " felt")
	#print("feltet er i disse sonene: ", cell_info.zone)
	#print("feltet er opptatt") if cell_info.occupied == true else print("feltet er ikke optatt")
	
	if clicked_cell not in neighbors:
		return
	move_player(clicked_cell)

func unset_occupied(tiles):
	for tile in tiles:
		var index = board.get_index_from_coor(tile)
		if index == null:
			print("Error, unset_occupied didn't find index for ", tile)
			continue
		board.tile_list[index].occupied = false

func end_turn():
	# Clear immediate chance card
	for c in $"../Playspace/Cards".get_children():
		c.queue_free()
	
	print("Slutt på runden, ny spiller sin tur")
	used_tiles.pop_back() # last tile stays occupied
	if battery < 1:
		out_of_battery()
	unset_occupied(used_tiles)
	used_tiles = [current_cell]
	update_ui.emit()
	# switch player here
	main.next_player()
	moves = max_moves + next_turn_moves_modifier
	next_turn_moves_modifier = 0
	update_ui.emit()
	
