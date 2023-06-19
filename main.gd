extends Node

@onready var board = $Board
@onready var Player = preload("res://player.tscn")
@onready var PlayerUI = preload("res://player_ui.tscn")
@onready var ChanceCardBase = preload("res://chance_card_base.tscn")
@onready var PlayerHand = preload("res://cards/player_hand.gd")
@onready var QuitUI = $QuitUI
@onready var MoveCounterUI = $MoveCounterUI
@onready var moveCounter = MoveCounterUI.get_node("Counter")
@onready var EndTurnUI = $EndTurnUI
@onready var screen_size = get_viewport().get_visible_rect().size
@onready var player_ui_positions = [
	Vector2(20,screen_size.y/2 - (500*0.4)/2 - 10), 
	Vector2(20,20),
	Vector2(screen_size.x - 750*0.4 -20,20), 
	Vector2(screen_size.x - 750*0.4 -20,screen_size.y/2 - (500*0.4)/2 -10),
	Vector2(screen_size.x - 750*0.4 -20,screen_size.y - (500*0.4) - 20),
	Vector2(20,screen_size.y - (500*0.4) - 20), 
	]

var players = []
@onready var num_selected_players = GameManager.num_selected_players
var current_active_player = 0
var special_cards = []
var chance_cards = []
var discard_pile = []
var card_effect
signal card_effect_done
var player_uis = []
var waiting = false
const CSVparser = preload("CSVParser.gd")
@onready var csv_parser = CSVparser.new()

func _ready():
	# create cards
	var chance_csv = get_chance_card_csv_data()
	add_chance_card_data(chance_csv)
	var special_csv = get_special_card_csv_data()
	add_special_card_data(special_csv)

	# MAKING A TEST CARD
	#	var cc = ChanceCardBase.instantiate()
	#	add_child(cc)
	#	var random_card = chance_cards.pick_random()
	#	cc.init(random_card)

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
		
		
		p.hand = PlayerHand.new()
		
		# Set sprites
		var p_sprite = p.get_node("Texture")
		var p_shadow = p.get_node("Texture/Shadow")
		var p_glow = p.get_node("Glow")
		
		# Texture path
		p_sprite.set_texture(load("res://player_assets/player{num}.png".format({"num":i})))
		p_sprite.scale *= 0.12
		p_glow.scale *= 0.12
		
		p_shadow.set_texture(p_sprite.texture)
	
	# Initialize UI's
	for i in num_selected_players:
		var p = players[i]
		var p_ui = PlayerUI.instantiate()
		player_uis.push_back(p_ui)
		add_child(p_ui) 
		var p_name
		var p_texture = load("res://player_card_assets/player{num}_card.png".format({"num":i}))
		var p_player_portrait = load("res://player_assets/player{num}.png".format({"num":i}))
		var p_side
		match(i):
			0:
				p_name =  "Fr0ya"
				p_side = "left"
			1:
				p_name = "L0k3"
				p_side = "left"
			2:
				p_name = "H3l"
				p_side = "right"
			3:
				p_name = "H3imdall"
				p_side = "right"
			4:
				p_name = "Bald3r"
				p_side = "right"
			5:
				p_name = "T0r"
				p_side = "left"

		p_ui.init(p,player_ui_positions[i],p_name,p_texture,p_player_portrait,p_side)
		p.player_name = p_name
		#p_ui.head.texture = p_player_head
		
		# Connect signals to UI elements
		p.update_ui.connect(MoveCounterUI._on_player_update_ui)
		p.update_ui.connect(p_ui._on_player_update_ui)
	
	# Set first player active
	players[0].active_player = true
	players[0].update_ui.emit()
	players[0].glow.visible = true
	player_uis[0].glow.visible = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and not QuitUI.visible:
		QuitUI.show()
		GameManager.play_select_sound()
	
	elif Input.is_action_just_pressed("ui_cancel") and QuitUI.visible:
		QuitUI.hide()
		GameManager.play_select_sound()
	
	# End turn on spacebar
	if Input.is_action_just_pressed("ui_accept") and GameManager.game_started:
		EndTurnUI._on_end_turn_button_pressed()

func next_player():
	if !GameManager.game_started:
		return
	players[current_active_player].active_player = false
	players[current_active_player].glow.visible = false
	player_uis[current_active_player].glow.visible = false
	current_active_player = (current_active_player+1)%num_selected_players
	players[current_active_player].active_player = true
	players[current_active_player].glow.visible = true
	player_uis[current_active_player].glow.visible = true
	players[current_active_player].start_turn()

func get_active_player():
	return players[current_active_player]

func _on_end_turn_ui_end_turn():
	players[current_active_player].end_turn()
	next_player()
	print("player "+str(current_active_player)+"'s turn")

func get_chance_card_csv_data():
	var chance_card_csv = "res://sjansekort.csv.txt"
	return csv_parser.parseCSV(chance_card_csv)

func get_special_card_csv_data():
	var special_card_csv = "res://sikkerhetsfeilkort.csv.txt"
	return csv_parser.parseCSV(special_card_csv)

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
	var in_hand = false
	
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

func add_special_card_data(data):
		for line in data:
			var card = Card.new()
			card.title = line[0]
			card.description = line[1]
			card.activation = line[2]
			card.polarity = line[3]
			card.type = "special"
			special_cards.append(card)

func shuffle_discard_into_deck():
	chance_cards += discard_pile
	discard_pile.clear()

func immediate_card_effect(card):
	match card.title:
		"N*kkel +":
			players[current_active_player].keys = min(10,players[current_active_player].keys+int(card.description[-1]))
		"N*kkel -":
			players[current_active_player].keys = max(0,players[current_active_player].keys-int(card.description[-1]))
		"Batteri +":
			players[current_active_player].battery = min(20,players[current_active_player].battery+int(card.description[-1]))
		"Batteri -":
			players[current_active_player].battery = max(0,players[current_active_player].battery-int(card.description[-1]))
		"Resirkulering":
			shuffle_discard_into_deck()
		"Overklokket":
			players[current_active_player].moves_modifier += 1
		"Overbelastet":
			players[current_active_player].moves_modifier -= 1
		"Virus":
			@warning_ignore("shadowed_variable") var next_player = (current_active_player+1)%num_selected_players
			card.target = current_active_player
			players[next_player].virus = card
			shuffle_discard_into_deck()
		"Hack":
			var curP = get_active_player() 
			curP.used_tiles.pop_back()
			curP.unset_occupied(curP.used_tiles)
			curP.used_tiles = [curP.current_cell]
			
			var target = await wait_player_select()
			var chance_tile = await wait_chance_select()
			target.move_to_tile(chance_tile)
			target.used_tiles = [target.current_cell]
			shuffle_discard_into_deck()

func wait_player_select():
	waiting = true
	moveCounter.text = "Velg en\nspiller!"
	var clicked_player
	var clicked_cell
	while true:
		await board.clicked
		var clicked_cell_pos = board.clicked_cell
		clicked_cell = board.tile_list[board.get_index_from_coor(clicked_cell_pos)]
		if (clicked_cell_pos not in get_active_player().used_tiles and clicked_cell.occupied and clicked_cell_pos != players[current_active_player].current_cell):
			# Find the right player
			clicked_player = players.filter(func(p): 
				return p.current_cell == clicked_cell_pos).front()
			break
	print("valid player")
	# TODO change move counter text
	# Add glow to player
	waiting = false
	return clicked_player

func wait_chance_select():
	waiting = true
	moveCounter.text = "Velg et\nsjansefelt!"
	var clicked_cell
	var clicked_cell_pos
	while true:
		await board.clicked
		clicked_cell_pos = board.clicked_cell
		clicked_cell = board.tile_list[board.get_index_from_coor(clicked_cell_pos)]
		print(clicked_cell.type)
		if (clicked_cell_pos not in get_active_player().used_tiles and !clicked_cell.occupied and clicked_cell.type == "card"):
			break
	print("valid cell")
	waiting = false
	MoveCounterUI._on_player_update_ui()
	clicked_cell.occupied = true
	return clicked_cell_pos


