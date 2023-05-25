extends AnimatableBody2D

# Player control variables
var board
var current_cell
@export var active_player : bool
var start_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	print("PLAYER READY")
	board = $"../Board"
	
	# Connect click signal from board to player
	board.clicked.connect(_on_board_clicked)

func init():
	current_cell = start_pos
	set_position(board.get_map_pos(current_cell))


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
