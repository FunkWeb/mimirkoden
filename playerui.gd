extends Node2D

@onready var player = $".."/Player
@onready var texture = $Texture

var pos = Vector2(0,0)
var element_offset = Vector2(0,40)


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_update_ui()
	
func init(playerP,posP,nameP,textureP,sideP):
	match sideP:
		"left":
			pass
		"right":
			pass
	self.player = playerP
	self.pos = posP
	$Name.text = nameP
	position = pos
	texture.set_texture(textureP)
	
	scale *= 0.4
#	$Name.position = posP
#	$ChargeCounter.position = posP + element_offset
#	$KeyCounter.position = posP + (element_offset * 2)

func _on_player_update_ui():
	$KeyCounter.text = str(player.keys)
	$ChargeCounter.text = str(player.battery)
