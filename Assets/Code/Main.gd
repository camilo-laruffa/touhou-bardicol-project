extends Node2D

onready var Player = preload("res://Assets/Scenes/Player.tscn")
onready var Wave = [preload("res://Assets/Scenes/Levels/st01_lv01.tscn")]

func _ready():	
	set_physics_process(true)
	var player = Player.instance()
	add_child(player)
	player.position = Vector2(300,530)
	var wave = Wave[0].instance()
	add_child(wave)
	wave.position = Vector2(0,0)
	
	


func _physics_process(delta):
	pass
