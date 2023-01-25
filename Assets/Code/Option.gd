extends Control


func _ready():
	$VBoxContainer/Music_slider.value = Global.music_volume
	$VBoxContainer/SFX_slider.value = Global.sfx_volume
	pass


func _on_Return_pressed():
	get_tree().change_scene("res://Assets/Scenes/Menu.tscn")

func _on_SFX_slider_value_changed(value):
	AudioManager.sfx_volume(value)
	AudioManager.play("Player miss")
	Global.sfx_volume = value


func _on_Music_slider_value_changed(value):
	AudioManager.music_volume(value)
	Global.music_volume = value
