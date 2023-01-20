extends Control


func _ready():
	$HBoxContainer/VBoxContainer2/Score.text = str(Global.score)
	$HBoxContainer/VBoxContainer2/Highscore.text = str(Global.highscore)
	$VBoxContainer/Continue.grab_focus()
	pass


func _on_Continue_pressed():
	get_tree().change_scene("res://Assets/Scenes/Game.tscn")


func _on_Menu_pressed():
	get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
