extends CanvasLayer

@onready var player = $".."/Player


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_update_ui()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_ui():
	$KeyCounter.text = "Keys: "+str(player.keys)
	$ChargeCounter.text = "Charges: "+str(player.battery)
	pass # Replace with function body.
