extends Node2D



const CardBase = preload("res://cards/chance_card_base.tscn")
const PlayerHand = preload("res://cards/player_hand.gd")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()

func _input(event):
	if Input.is_action_just_released("middleclick"):
		var new_card = CardBase.instantiate()
		
