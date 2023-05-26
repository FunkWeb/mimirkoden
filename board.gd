extends TileMap

var clicked_cell
var all_cells = get_used_cells(0)
var map_coords
var grid_data : Dictionary = {}
signal clicked
var tile_list = []

func _ready():
	make_tile_list()

func _unhandled_input(event):
	# Check for mouse left click
	if !(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	clicked_cell = local_to_map(get_local_mouse_position())
	if clicked_cell not in all_cells: # Check if clicked cell is on the board
		return 
	map_coords = get_map_pos(clicked_cell) # Returns cell map coordinates
	clicked.emit()
	
	var tile_index = get_index_from_coor(clicked_cell)
	print("Clicked on ",all_cells[tile_index] , " Type: ",tile_list[tile_index].type)

func get_map_pos(pos):
	# Gets global pixel position of center of a tile
	return to_global(map_to_local(pos))

func get_valid_neighbors(cell):
	var neighbors = get_surrounding_cells(cell)
	var valid = []
	for n in neighbors:
		if check_valid(n):
			valid.push_back(n)
	return valid

func check_valid(cell):
	var tile_index = get_index_from_coor(cell)
	if tile_index == null:
		return false
	if tile_list[tile_index].has_moved_to_in_current_turn == true:
		return false 
	if tile_list[tile_index].type == "wall":
		# walk through walls card check
		return false
	if tile_list[tile_index].type == "lock" or tile_list[tile_index].type == "win":
		# key check
		return false
	return true

func get_index_from_coor(coor):
	for i in range(127):
		if all_cells[i] == coor:
			return i

class Tile:
	var type #ground, start, wall, shop, card, win, negative, lock, special_card
	var group #grey, red, purple, blue, teal, green, yellow
	var walkable
	var occupied
	var has_moved_to_in_current_turn
	func _init():
		type = "ground"
		group = []
		walkable = true
		occupied = false
		has_moved_to_in_current_turn = false

		
func make_tile_list():
	for tile in range(127): # iterate over all tiles
		var object = Tile.new()
		tile_list.append(object)
		if tile in [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48]:
			object.type = "wall"
		elif tile in [7, 11, 15, 73, 75, 77, 79, 82, 86, 90, 94, 98, 99, 101, 103, 105, 106, 126]:
			object.type = "negative"
		elif tile in [4, 6, 8, 10, 12, 14, 49, 57, 65, 76, 89, 102]:
			object.type = "card"
		elif tile in [51, 55, 59, 63, 67, 71]:
			object.type = "start"
		elif tile in [53, 61, 69]:
			object.type = "shop"
		elif tile in [16, 17, 18]:
			object.type = "lock"
		elif tile in [0, 1, 3]:
			object.type = "special_card"
		elif tile == 2:
			object.type = "win"
		# else object.type = "ground"

