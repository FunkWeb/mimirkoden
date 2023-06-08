extends Node2D

const CardBase = preload("res://chance_card_base.tscn")
const PlayerHand = preload("res://cards/player_hand.gd")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

func draw_card(player,card):
	var new_card = CardBase.instantiate()
	$Cards.add_child(new_card)
	new_card.init(card)
	new_card.set_global_position(Vector2(300,600))
