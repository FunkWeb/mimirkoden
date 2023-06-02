extends Node

@onready var board = $Board
@onready var Player = preload("res://player.tscn")
@onready var PlayerUI = preload("res://player_ui.tscn")
@onready var StartUI = $StartUI
@onready var QuitUI = $QuitUI
@onready var MoveCounterUI = $MoveCounterUI
var game_started = false
var players = []
var num_selected_players = 2  # Default value
var current_active_player = 0

var player_uis = []
var player_ui_positions = [Vector2(20,20),Vector2(20,580),Vector2(20,280),
	Vector2(1000,20),Vector2(1000,580),Vector2(1000,280)]
	
const CSVparser = preload("CSVParser.gd")
@onready var csv_parser = CSVparser.new()
var csv_data
var chance_cards = []

func _ready():
	QuitUI.hide()
	StartUI.update_player_count(num_selected_players)
	get_csv_data()
	add_card_data(csv_data)

func get_csv_data():
	var csvPath = "res://sjansekort.csv.txt" # Replace with your CSV file path
	csv_data = csv_parser.parseCSV(csvPath)

class Chance_card:
	var name
	var description
	var activation
	var alignment 

func add_card_data(data):
	for line in data:
		var card = Chance_card.new()
		card.name = line[0]
		card.description = line[1]
		card.activation = line[2]
		card.alignment = line[3]
		chance_cards.append(card)
	print(len(chance_cards))

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		StartUI.hide()
		QuitUI.show()
	
	# TESTING PLAYER SWITCHING
	if Input.is_action_just_pressed("ui_accept"):
		print("SWITCH")
		next_player()


func _on_start_ui_players(num: int):
	num_selected_players = num


func _on_start_ui_start_game():
	StartUI.hide()
	start()

func start():
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
	
	
	# Set first player active
	players[0].active_player = true

func next_player():
	players[current_active_player].active_player = false
	current_active_player = (current_active_player+1)%num_selected_players
	players[current_active_player].active_player = true

	

