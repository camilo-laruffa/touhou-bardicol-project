extends Node

var score = 0
var highscore = 0
var power = 1
var bombs = 2
var lives = 3
var sfx_volume = -30
var music_volume = -10

func _process(delta):
	if score > highscore : highscore = score
	pass
	
func parametrear(score,power,bombs,lives):
	self.lives = lives
	self.score = score
	self.power = power
	self.bombs = bombs
