extends Node
# global scene is loaded in with every scene
# project > project settings > autoload
# Scene > Remote mens spillet kjører
@onready var select_sound = $SelectSound
@onready var game_music = $BackgroundMusic
@onready var win_music = $WinBackgroundMusic
var game_started = false
var winning_player = "Du" # temp value

func _ready():
	play_background_music()

func change_scene_to_game():
	game_started = true
	get_tree().change_scene_to_file("main.tscn")

func change_scene_to_rules():
	get_tree().change_scene_to_file("Rules.tscn")

func change_scene_to_credits():
	get_tree().change_scene_to_file("Credits.tscn")

func change_scene_to_menu():
	game_started = false
	get_tree().change_scene_to_file("Menu.tscn")

func change_scene_to_win():
	game_started = false
	get_tree().change_scene_to_file("WinScreen.tscn")

func quit_game():
	get_tree().quit()

func play_background_music():
	win_music.stop()
	game_music.play()

func play_win_music():
	game_music.stop()
	win_music.play()

func play_select_sound():
	select_sound.play()
