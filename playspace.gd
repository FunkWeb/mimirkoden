extends Node2D

const ChanceCardBase = preload("res://chance_card_base.tscn")
const ErrorCardBase = preload("res://error_card_base.tscn")
#const PlayerHand = preload("res://cards/player_hand.gd")
var CardSelected = []
#@onready var DeckSize = PlayerHand.CardList.size()

func draw_card(card):
	var new_card = ChanceCardBase.instantiate()
	$Cards.add_child(new_card)
	new_card.init(card)
	new_card.set_global_position(Vector2(250,600))

func draw_error_card(card):
	var new_card = ErrorCardBase.instantiate()
	$Cards.add_child(new_card)
	new_card.init(card)
	new_card.set_global_position(Vector2(get_viewport_rect().size/2 - new_card.size/2))
