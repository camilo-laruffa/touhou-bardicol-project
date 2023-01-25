extends Control

onready var AUDIOMANAGER = preload("res://Assets/Scenes/AudioManager.tscn")
var Music
var SFX

func _ready():
	$VBoxContainer/Start.grab_focus()
	AudioManager.change_music("res://Assets/Sounds/menu_music.mp3")

func _on_Start_pressed():
	get_tree().change_scene("res://Assets/Scenes/Game.tscn")
	AudioManager.stop_music()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Option_pressed():
	get_tree().change_scene("res://Assets/Scenes/Option.tscn")
