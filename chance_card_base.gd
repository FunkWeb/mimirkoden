extends MarginContainer

@onready var card_title = $Contents/Title
@onready var card_desc = $Contents/Description
@onready var card_activation = $Activation

var title
var desc
var activation
var polarity
var in_hand
@onready var texture = $Texture



func init(CardData):
	in_hand = CardData.in_hand
	title = CardData.title
	desc = CardData.description
	activation = CardData.activation
	polarity = CardData.polarity
	
	print(polarity)
	card_title.text = title
	match(polarity):
		"Negativt":
			card_title.set("theme_override_colors/font_outline_color",Color("#ff0000"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#ff0000"))
			texture.texture = load("res://card_assets/frame_card_neg.png")
		"Positivt":
			card_title.set("theme_override_colors/font_outline_color",Color("#00ff00"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#00ff00"))
			texture.texture = load("res://card_assets/frame_card_pos.png")
		"Nøytralt":
			card_title.set("theme_override_colors/font_outline_color",Color("#ffffff"))
			card_desc.set("theme_override_colors/font_outline_color",Color("#ffffff"))
			texture.texture = load("res://card_assets/frame_card_neu.png")
	
	card_desc.text = desc
	card_activation.text = activation
	
	# Shrink text to fit
	var title_len = card_title.get_total_character_count()
	var title_size = remap(title_len,4,16,56,28)
	card_title.set("theme_override_font_sizes/font_size",title_size)

func _on_mouse_entered():
	if !in_hand: return
	set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	position.y = -200

func _on_mouse_exited():
	if !in_hand: return
	position.y = 0

func _gui_input(event):
	if !in_hand: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(self)
			play_self()

func play_self():
	var player = $"/root/Main".players[$"/root/Main".current_active_player]
	player.use_card(self)
	
	self.queue_free()
