extends CanvasLayer

@onready var player = $".."/Player

var pos = Vector2(0,0)
var element_offset = Vector2(0,20)


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_update_ui()
	
func init(player,pos,name):
	self.player = player
	self.pos = pos
	$Name.text = name
	$Name.position = pos
	$ChargeCounter.position = pos + element_offset
	$KeyCounter.position = pos + (element_offset * 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_ui():
	$KeyCounter.text = "Keys: "+str(player.keys)
	$ChargeCounter.text = "Charges: "+str(player.battery)
