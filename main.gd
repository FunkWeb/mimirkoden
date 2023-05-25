extends Node

@onready var board = $Board
@onready var Player = preload("res://player.tscn")

var players = [] 
var num_selected_players = 3 # Will be set by start menu
var current_active_player = 0

func _ready():
	
	# TEMP, WILL BE ACTIVATED BY START MENU
	start()


func start():
	# Create X number of players
	for n in num_selected_players:
		players.push_back(Player.instantiate())
	
	# Initialize players
	var start_positions = [Vector2i(-7,-1),Vector2i(-4,-7),Vector2i(2,-7),Vector2i(5,-1),Vector2i(2,5),Vector2i(-4,5)]
	for i in num_selected_players:
		var p = players[i]
		add_child(p)
		p.start_pos = start_positions[i]
		p.init()
		
		# Set sprites and link UI elements
		var p_sprite = p.get_node("Sprite2D")
		
		# Texture path
		p_sprite.set_texture(load("res://player_assets/player{num}.png".format({"num":i})))
		
		# Link UI
		# INSERT CODE HERE
	
	# Set first player active
	players[0].active_player = true

func next_player():
	players[current_active_player].active_player = false
	current_active_player = (current_active_player+1)%num_selected_players
	players[current_active_player].active_player = true

func _process(_delta):
	
	# TESTING PLAYER SWITCHING
	if Input.is_action_just_pressed("switch_player"):
		print("SPACE")
		next_player()
