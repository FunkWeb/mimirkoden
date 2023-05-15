class_name CellData extends Board

var tile_pos: Vector2i
var type: String
var map_pos: Vector2
var available: bool
var occupied: bool

# Called upon instancing class
func _init(tile,type_arg,map_pos_arg):
	tile_pos = tile
	type = type_arg
	map_pos = map_pos_arg
	
	# Sets ground tiles to be walkable
	if (type == "ground"):
		available = true
	else:
		available = false
