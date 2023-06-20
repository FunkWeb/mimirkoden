extends CanvasLayer
@onready var current_player# Need to find current active player
@onready var main = $".."

func _on_player_update_ui():
	if(main.waiting): return;
	current_player = main.players[main.current_active_player]
	$Counter.text = current_player.player_name+"\nFlytt:\n"+str(current_player.moves)
