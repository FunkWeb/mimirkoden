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
	
	# Set first player active
	players[0].active_player = true

func next_player():
	players[current_active_player].active_player = false
	current_active_player = (current_active_player+1)%num_selected_players
	players[current_active_player].active_player = true

func get_chance_card_csv_data():
	var chance_card_csv = "res://sjansekort.csv.txt"
	return csv_parser.parseCSV(chance_card_csv)

class Card:
	var title
	var description
	var activation # umiddelbar eller valgfri
	var polarity # positiv, negativ, neutral
	
class Shop_card extends Card:
	var cost

func add_chance_card_data(data):
	for line in data:
		var card = Card.new()
		card.title = line[0]
		card.description = line[1]
		card.activation = line[2]
		card.polarity = line[3]
		chance_cards.append(card)

func shuffle_discard_into_deck():
	chance_cards += discard_pile
	discard_pile.clear()

func immediate_card_effect(card):
	if card.title == "Nøkkel +":
		players[current_active_player].keys = min(10,players[current_active_player].keys+int(card.description[-1]))
	elif card.title == "Nøkkel -":
		players[current_active_player].keys = max(0,players[current_active_player].keys-int(card.description[-1]))
	elif card.title == "Batteri +":
		players[current_active_player].battery = min(20,players[current_active_player].battery+int(card.description[-1]))
	elif card.title == "Batteri -":
		players[current_active_player].battery = max(0,players[current_active_player].battery-int(card.description[-1]))
	elif card.title == "Resirkulering":
		shuffle_discard_into_deck()
	elif card.title == "Overklokket":
		players[current_active_player].next_turn_moves_modifier = 1
	elif card.title == "Overbelastet":
		players[current_active_player].next_turn_moves_modifier = -1
	elif card.title == "Virus":
			card_effect = true
			# display which player is in control
			move_to_chance(current_active_player)
			card_effect = false
	elif card.title == "Hack":
		card_effect = true
		var player
		var clicked_cell # get clicked cell somehow
		for player_index in len(players):
			if players[player_index].active_player:
				continue # don't pick yourself
			if players[player_index].current_pos == clicked_cell:
				player = player_index
		move_to_chance(player)
		card_effect = false

func move_to_chance(player): # index or current_active_player
	var clicked_cell # get clicked cell somehow
	if board.tile_list[board.get_index_from_coor(clicked_cell)].occupied == true:
	# if occupied, a player is on it
	# problem, starting tiles are set as occupied
		players[player].move_to_tile(clicked_cell)
