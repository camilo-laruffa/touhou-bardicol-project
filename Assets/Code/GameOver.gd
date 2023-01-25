extends Control


func _ready():
	$HBoxContainer/VBoxContainer2/Score.text = str(Global.score)
	$HBoxContainer/VBoxContainer2/Highscore.text = str(Global.highscore)
	$VBoxContainer/Continue.grab_focus()
	AudioManager.change_music("res://Assets/Sounds/perdiste_music.mp3")
	pass


func _on_Continue_pressed():
	get_tree().change_scene("res://Assets/Scenes/Game.tscn")


func _on_Menu_pressed():	
	AudioManager.change_music("res://Assets/Sounds/menu_music.mp3")
	get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
