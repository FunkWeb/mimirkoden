extends CanvasLayer

@onready var player = $".."/Player

var pos = Vector2(0,0)
var element_offset = Vector2(0,40)


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_update_ui()
	
func init(playerP,posP,nameP):
	self.player = playerP
	self.pos = posP
	$Name.text = nameP
	$Name.position = posP
	$ChargeCounter.position = posP + element_offset
	$KeyCounter.position = posP + (element_offset * 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_update_ui():
	$KeyCounter.text = "N*kler: "+str(player.keys)
	$ChargeCounter.text = "Batteri: "+str(player.battery)
