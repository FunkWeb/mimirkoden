extends Node2D

const CardBase = preload("res://chance_card_base.tscn")
var chance_cards: Array
const PlayerHand = preload("res://cards/player_hand.gd")
var CardSelected = []
var initialized = false
@onready var DeckSize = PlayerHand.CardList.size()

func _input(event):
	if(!initialized):
		return

	if Input.is_action_just_released("middleclick"):
		var new_card = CardBase.instantiate()
		add_child(new_card)
		new_card.init(chance_cards.pick_random())
		new_card.set_position(get_global_mouse_position())

func init(chance_cards_in):
	chance_cards = chance_cards_in
	initialized = true
