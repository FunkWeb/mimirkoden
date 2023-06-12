extends MarginContainer

@onready var card_title = $Contents/Title
@onready var card_desc = $Contents/Description

var title
var desc
var polarity

func init(CardData):
	title = CardData.title
	desc = CardData.description
	polarity = CardData.polarity
	
	print(polarity)
	card_title.text = title
	card_desc.text = desc
	match(polarity):
		"Negativt":
			card_title.set("theme_override_colors/font_outline_color",Color("#ff0000"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#ff0000"))
		"Positivt":
			card_title.set("theme_override_colors/font_outline_color",Color("#00ff00"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#00ff00"))
