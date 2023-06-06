extends CanvasLayer

signal end_turn

@onready var main = $".."
@onready var select_sound = $".."/SelectSound
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_turn_button_pressed():
	select_sound.play()
	end_turn.emit()
	pass # Replace with function body.
