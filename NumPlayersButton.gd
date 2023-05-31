extends MenuButton

var popup
# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	for i in range(2,7):
		popup.add_item(str(i),i)
	popup.id_pressed.connect($".."._on_num_players_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
