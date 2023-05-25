extends CanvasLayer
@onready var current_player = $".."/Player # Need to find current active player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_ui():
	$Counter.text = "Moves\n"+str(current_player.moves)
