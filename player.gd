extends AnimatableBody2D

var start_pos
var current_cell
@export var active_player:bool
const max_moves = 10 # testing wall_walk
var moves
var key_card
var virus # Virus card. Stores card value to send to the player
var moves_modifier = 0
var cell_index
var inventory = []
var keys # max 10
var battery # max 20
var new_tile # new tile just moved to
var used_tiles # track tiles moved to in current turn
var walk_walls # if card used to walk through walls
var negative_card_effects = []
signal update_ui # emit whenever the ui needs to update values (moves, charges, etc...)
@onready var main = $".."
@onready var board = $"../Board"
@onready var move_sound = $"../MoveSound"
# Called when the node enters the scene tree for the first time.
func _ready():
	battery = 0
	moves = max_moves
	keys = 0
	walk_walls = true # set true for testing
	used_tiles = []
	# Connect click signal from board to player
	board.clicked.connect(_on_board_clicked)

func init():
	current_cell = start_pos
	set_position(board.get_map_pos(current_cell))

func resolve_negative_card_effects():
	for i in len(negative_card_effects):
		match negative_card_effects[i].title:
			# "Forsikring" (chance card) mot stjeling
			# "Forsikring" (shop card)  mot kort brukt av en spiller
			# "Brannmur" mot sjansekort
			# "Premium Brannmur", "Anti-Virus" mot alt
			"Nøkkel -":
				# TODO option to use defense card if you have them
				# brannmur, premium brannmur, anti-virus
				keys = max(0,keys-int(negative_card_effects[i].description[-1]))
			"Batteri -":
				# TODO option to use defense card if you have them
				# brannmur, premium brannmur, anti-virus
				battery = max(0,battery-int(negative_card_effects[i].description[-1]))
			"Overbelastet":
				# TODO option to use defense card if you have them
				# brannmur, premium brannmur, anti-virus
				moves_modifier -= 1
			"Hack":
				# TODO option to use defense card if you have them
				# brannmur, premium brannmur, anti-virus, Forsikring" (shop card)
				move_to_tile(negative_card_effects[i].tile)
			"Virus":
				# TODO option to use defense card if you have them
				# brannmur, premium brannmur, anti-virus, Forsikring" (shop card)
				move_to_tile(negative_card_effects[i].tile)
			"Små Feil":
				# TODO option to use defense card if you have them
				# premium brannmur, anti-virus
				keys = max(0, keys-3)
			"Tvunget Avsluttning":
				# TODO option to use defense card if you have them
				# premium brannmur, anti-virus
				move_to_tile(start_pos)

func get_defense_cards():
	var cards = []
	for card in inventory:
		if card.title in ["Forsikring", "Brannmur", "Premium Brannmur", "Anti-Virus"]:
			cards.append(card)
	return cards

func start_turn():
	update_ui.emit()
	if virus: # last player got a virus, you pick a chance tile for them
		var chance_tile # TODO pick a tile
		virus.tile = chance_tile
		main.players[virus.target].negative_card_effects.append(virus)
		virus = null
	if len(negative_card_effects) > 0:
		var defense_cards = get_defense_cards()
		resolve_negative_card_effects()
	
	moves = max_moves + moves_modifier
	moves_modifier = 0

func new_tile_effect(tile):
	match tile.type:
		"ground":
			battery += 1
			battery = min(battery, 20) # max 20 battery
		"double":
			battery += 2
			battery = min(battery, 20)
		"negative":
			battery -= 1
			if battery < 0: # less than 0
				out_of_battery()
		"lock":
			moves = 0
			if key_card:
				key_card = false
			else:
				keys -= 5
		"special_card":
			moves = 0
			draw_special_card()
		"shop":
			moves = 0
			item_shop()
		"card":
			moves = 0
			draw_card()
		"wall":
			moves += 1 # don't use a move
			walk_walls = false
		"win":
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
	if card.activation == "Umiddelbar Aktivering":
		main.discard_pile.append(card)
		main.immediate_card_effect(card)
	else:
		inventory += [card]
		pass

func draw_special_card():
	# TODO display card for player
	var card_index = randi_range(0,2)
	var card = main.special_cards[card_index]
	if card.polarity == "Positivt":
		print("ingenting skjer")
		return
	elif card.polarity == "Negativt":
		negative_card_effects.append(card)

func use_card(inv_index):
	# use a card from inventory
	var card = inventory.pop_at(inv_index)
	main.discard_pile.append(card)
	match card.name:
		"Bakdør":
			walk_walls = true
			main.shuffle_discard_into_deck()
		"Krypteringnøkkel":
			key_card = true
		"Premium Brannmur":
			pass
		"Forsikring":
			pass
		"Anti-Virus":
			pass

func move_to_tile(cell):
	unset_occupied([current_cell])
	current_cell = board.get_local_pos(cell)
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
	if !main.game_started or !active_player or moves == 0:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell, true)
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
	print("Slutt på runden, ny spiller sin tur")
	used_tiles.pop_back() # last tile stays occupied
	if battery < 1:
		out_of_battery()
	unset_occupied(used_tiles)
	used_tiles = [current_cell]
	update_ui.emit()
	# switch player here
	main.next_player()

