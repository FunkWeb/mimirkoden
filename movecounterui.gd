extends CanvasLayer
@onready var current_player# Need to find current active player
@onready var main = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_update_ui():
	current_player = main.players[main.current_active_player]
	$Counter.text = "Moves\n"+str(current_player.moves)
