extends Control

func _ready():
	$HBoxContainer/Highscore.text = str(Global.highscore)

func _process(delta):
	$HBoxContainer2/Score.text = str(Global.score)
	$HBoxContainer3/Lives_lb.text = str(Global.lives)
	$HBoxContainer4/Bombs_lb.text = str(Global.bombs)
	$HBoxContainer5/Power_lb.text = str(Global.power)
