extends Node2D

var time = 0

func _ready():
	pass

func _process(delta):
	time += delta
	modulate.a = sin(time * 4)
	pass
