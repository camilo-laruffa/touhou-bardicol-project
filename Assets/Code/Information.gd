extends Control

func _ready():
	$Vbox/HBoxContainer/Highscore.text = str(Global.highscore)

func _process(delta):
	$Vbox/HBoxContainer2/Score.text = str(Global.score)
	$Vbox/HBoxContainer3/Lives_lb.text = str(Global.lives)
	$Vbox/HBoxContainer4/Bombs_lb.text = str(Global.bombs)
	$Vbox/HBoxContainer5/Power_lb.text = str(Global.power)
	
	pass
