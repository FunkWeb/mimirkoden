extends AnimatableBody2D

var board
var current_cell
@export var active_player:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	board = $"../Board"
	
	var start_pos = board.get_map_pos(Vector2(-1,-1))
	set_position(start_pos)
	current_cell = Vector2(-1,-1)

func _on_board_clicked():
	if !active_player:
		return
	
	var neighbors = board.get_valid_neighbors(current_cell)
	var clicked_cell = board.clicked_cell
	
	if clicked_cell not in neighbors:
		return
	
	var cell_pos = board.map_coords
	set_position(cell_pos)
	current_cell = clicked_cell
