extends Node

@onready var board = $Board
@onready var Player = preload("res://player.tscn")
@onready var PlayerUI = preload("res://player_ui.tscn")
@onready var ChanceCardBase = preload("res://chance_card_base.tscn")
@onready var StartUI = $StartUI
@onready var QuitUI = $QuitUI
@onready var MoveCounterUI = $MoveCounterUI
@onready var screen_size = get_viewport().get_visible_rect().size
@onready var player_ui_positions = [
	Vector2(20,screen_size[1]/2 - 60), 
	Vector2(20,20),
	Vector2(screen_size[0] - 220,20), 
	Vector2(screen_size[0] - 220,screen_size[1]/2 - 60),
	Vector2(screen_size[0] - 220,screen_size[1] - 140),
	Vector2(20,screen_size[1] - 140), 
	]

var players = []
var num_selected_players = 2  # Default value
var current_active_player = 0
var chance_cards = []
var discard_pile = []
var card_effect
signal card_effect_done
var player_uis = []
	
var game_started = false
const CSVparser = preload("CSVParser.gd")
@onready var csv_parser = CSVparser.new()

func _ready():
	QuitUI.hide()
	StartUI.update_player_count(num_selected_players)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and not QuitUI.visible:
		StartUI.hide()
		QuitUI.show()
		$SelectSound.play()
		
	elif Input.is_action_just_pressed("ui_cancel") and QuitUI.visible:
		$SelectSound.play()
		QuitUI.hide()
		if not game_started:
			StartUI.show()
	
	# TESTING PLAYER SWITCHING
	if Input.is_action_just_pressed("ui_accept"):
		print("SWITCH")
		next_player()

func _on_start_ui_players(num: int):
	num_selected_players = num

func _on_start_ui_start_game():
	StartUI.hide()
	start()
	
	print(screen_size)

func start():
	# create cards
	var csv_data = get_chance_card_csv_data()
	add_chance_card_data(csv_data)
	
	
	
	# MAKING A TEST CARD
	var cc = ChanceCardBase.instantiate()
	add_child(cc)
	cc.init(chance_cards[0])

	# Create X number of players and UI elements
	for n in num_selected_players:
		players.push_back(Player.instantiate())
	
	# Initialize players
	var start_positions = [Vector2i(-8,-1),Vector2i(-4,-8),Vector2i(3,-8),Vector2i(6,-1),Vector2i(3,6),Vector2i(-4,6)]
	for i in num_selected_players:
		var p = players[i]
		add_child(p)
		p.start_pos = start_positions[i]
		p.init()
		
		# Set sprites
		var p_sprite = p.get_node("Sprite2D")
		
		# Texture path
		p_sprite.set_texture(load("res://player_assets/player{num}.png".format({"num":i})))
	
	# Initialize UI's
	for i in num_selected_players:
		var p = players[i]
		var p_ui = PlayerUI.instantiate()
		player_uis.push_back(p_ui)
		add_child(p_ui) 
		p_ui.init(p,player_ui_positions[i],"Player "+str(i+1))
		
		# Connect signals to UI elements
		p.update_ui.connect(MoveCounterUI._on_player_update_ui)
		p.update_ui.connect(p_ui._on_player_update_ui)
		
	
	game_started = true
	$EndTurnUI.show()
	
	# Set first player active
	players[0].active_player = true
	players[0].update_ui.emit()

func next_player():
	if !game_started:
		return
	players[current_active_player].active_player = false
	current_active_player = (current_active_player+1)%num_selected_players
	players[current_active_player].active_player = true
	players[current_active_player].start_turn()

func _on_end_turn_ui_end_turn():
	players[current_active_player].end_turn()
	print("player "+str(current_active_player+1)+"'s turn")
	pass # Replace with function body.

func get_chance_card_csv_data():
	var chance_card_csv = "res://sjansekort.csv.txt"
	return csv_parser.parseCSV(chance_card_csv)

class Card:
	var type # "chance", "shop", "special"
	var title
	var description
	var activation # umiddelbar eller valgfri
	var polarity # positiv, negativ, neutral
	# some cards will store values in these:
	var user
	var target
	var tile
	
class Shop_card extends Card:
	var cost

func add_chance_card_data(data):
	for line in data:
		var card = Card.new()
		card.title = line[0]
		card.description = line[1]
		card.activation = line[2]
		card.polarity = line[3]
		card.type = "chance"
		chance_cards.append(card)

func shuffle_discard_into_deck():
	chance_cards += discard_pile
	discard_pile.clear()

func immediate_card_effect(card):
	match card.title:
		"Nøkkel +":
			players[current_active_player].keys = min(10,players[current_active_player].keys+int(card.description[-1]))
		"Nøkkel -":
			players[current_active_player].negative_card_effects.append(card)
		"Batteri +":
			players[current_active_player].battery = min(20,players[current_active_player].battery+int(card.description[-1]))
		"Batteri -":
			players[current_active_player].negative_card_effects.append(card)
		"Resirkulering":
			shuffle_discard_into_deck()
		"Overklokket":
			players[current_active_player].moves_modifier += 1
		"Overbelastet":
			players[current_active_player].negative_card_effects.append(card)
		"Virus":
			var next_player = (current_active_player+1)%num_selected_players
			card.target = current_active_player
			players[next_player].virus = card
			shuffle_discard_into_deck()
		"Hack":
			var target # pick player
			var chance_tile # pick chance tile
			card.target = target
			card.user = current_active_player
			card.tile = chance_tile
			players[target].negative_card_effects.append(card)
			shuffle_discard_into_deck()

func pick_other_player():
	print("velg en spiller du vil flytte")
	var clicked_cell # TODO find clicked cell
	for player_index in len(players):
		if player_index == current_active_player:
			continue # don't pick yourself
		if players[player_index].current_pos == clicked_cell:
			return player_index

func move_to_chance(player = -1):
	if player == -1:
		player = pick_other_player()
	print("velg et sjansefelt du vil flytte spiller ",player+1," til")
	var clicked_cell # TODO find clicked cell
	if board.tile_list[board.get_index_from_coor(clicked_cell)].type == "chance":
		players[player].move_to_tile(clicked_cell)
