extends MarginContainer

@onready var card_title = $Contents/Title
@onready var card_desc = $Contents/Description
@onready var card_activation = $Activation

func init(CardData):
	print(CardData.polarity)
	card_title.text = CardData.title
	match(CardData.polarity):
		"Negativt":
			card_title.set("theme_override_colors/font_outline_color",Color("#ff0000"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#ff0000"))
		"Positivt":
			card_title.set("theme_override_colors/font_outline_color",Color("#00ff00"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#00ff00"))
		"Nøytralt":
			card_title.set("theme_override_colors/font_outline_color",Color("#ffffff"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#ffffff"))
	
	card_desc.text = CardData.description
	card_activation.text = CardData.activation
	
