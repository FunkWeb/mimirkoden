extends CanvasLayer

@onready var select_sound = $"../SelectSound"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_quit_pressed():
	select_sound.play()
	get_tree().quit()


func _on_cancel_pressed():
	hide()
	select_sound.play()
	
	if not $"..".game_started:
		$".."/StartUI.show()

