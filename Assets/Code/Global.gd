extends Node

var score = 0
var highscore = 0

func _process(delta):
	if score > highscore : highscore = score
	pass
