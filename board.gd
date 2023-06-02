extends TileMap

var clicked_cell
var all_cells = get_used_cells(0)
var map_coords
var grid_data : Dictionary = {}
signal clicked
var tile_list = []
@onready var main = $".."
var active_player


func _ready():
	make_tile_list()
	add_tile_zones()

func _unhandled_input(event):
	if !(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	clicked_cell = local_to_map(get_local_mouse_position())
	if clicked_cell not in all_cells: # Check if clicked cell is on the board
		return
	map_coords = get_map_pos(clicked_cell) # Returns cell map coordinates
	clicked.emit()

func get_map_pos(pos):
	return to_global(map_to_local(pos))

func get_local_pos(pos):
	return local_to_map(to_local(pos))

func get_valid_neighbors(cell):
	var neighbors = get_surrounding_cells(cell)
	var valid = []
	for n in neighbors:
		if check_valid(n):
			valid.push_back(n)
	return valid

func get_index_from_coor(coor):
	for i in len(all_cells):
		if all_cells[i] == coor:
			return i

func check_valid(cell):
	active_player = main.players[main.current_active_player]
	var tile_index = get_index_from_coor(cell)
	if tile_index == null:
		return false
	var tile = tile_list[tile_index]
	if tile.occupied or (tile.type == "wall" and not active_player.walk_walls) or\
		(tile.type == "lock" or tile.type == "win") and active_player.keys < 5:
		return false
	return true

class Tile:
	var type #start, ground, double, wall, shop, card, win, negative, lock, special_card
	var zone #zones for card effects
	var walkable
	var occupied
	func _init():
		zone = []  #grey, red, purple, blue, teal, green, yellow
		walkable = true
		occupied = false

func add_tile_zones():
	for i in len(all_cells):
		if i in [0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 51, 55, 59, 63, 67, 71, 76, 80, 88, 89, 97, 98, 102, 106, 107, 112, 121, 126]:
			tile_list[i].zone.append("grey")
		if i in [49, 50, 51, 71, 72, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 126]:
			tile_list[i].zone.append("blue")
		if i in [33, 67, 68, 69, 70, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98]:
			tile_list[i].zone.append("teal")
		if i in [63, 64, 65, 66, 67, 97, 98, 99, 100, 101, 102, 121, 122, 123, 124, 125]:
			tile_list[i].zone.append("green")
		if i in [59, 60, 61, 62, 63, 102, 103, 104, 105, 106, 107, 117, 118, 119, 120, 121]:
			tile_list[i].zone.append("yellow")
		if i in [55, 56, 57, 58, 59, 73, 74, 75, 76, 106, 107, 108, 109, 110, 111, 112]:
			tile_list[i].zone.append("red")
		if i in [51, 52, 53, 54, 55, 76, 77, 78, 79, 80, 112, 113, 114, 115, 116, 126]:
			tile_list[i].zone.append("purple")

func make_tile_list():
	for tile in len(all_cells): # iterate over all tiles
		var object = Tile.new()
		tile_list.append(object)
		if tile in [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48]:
			object.type = "wall"
		elif tile in [7, 11, 15, 73, 75, 77, 79, 82, 86, 90, 94, 98, 99, 101, 103, 105, 106, 126]:
			object.type = "negative"
		elif tile in [4, 6, 8, 10, 12, 14, 49, 57, 65, 76, 89, 102]:
			object.type = "card"
		elif tile in [51, 55, 59, 63, 67, 71]:
			object.type = "double"
		elif tile in [53, 61, 69]:
			object.type = "shop"
		elif tile in [16, 17, 18]:
			object.type = "lock"
		elif tile in [0, 1, 3]:
			object.type = "special_card"
		elif tile == 2:
			object.type = "win"
		elif tile > 126: # starting tiles
			object.type = "start"
			object.occupied = true
			object.walkable = false
		else:
			object.type = "ground"
	
