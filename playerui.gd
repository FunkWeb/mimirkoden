extends Node2D

@onready var player = $".."/Player
@onready var texture = $Texture
@onready var portrait = $Portrait
@onready var glow = $Glow

var pos = Vector2(0,0)
var element_offset = Vector2(0,40)


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_player_update_ui()
	
func init(playerP,posP,nameP,textureP,headP,sideP):
	match sideP:
		"left":
			$Name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			$KeyCounter.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			$ChargeCounter.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			pass
		"right":
			glow.position.x = 216
			$Name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			$KeyCounter.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			$ChargeCounter.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			portrait.offset.x = -420
			pass
	self.player = playerP
	self.pos = posP
	$Name.text = nameP
	position = pos
	texture.set_texture(textureP)
	portrait.set_texture(headP)
	
	scale *= 0.4

func _on_player_update_ui():
	$KeyCounter.text = str(player.keys)
	$ChargeCounter.text = str(player.battery)
